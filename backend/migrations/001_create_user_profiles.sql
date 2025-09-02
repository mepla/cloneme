-- Migration: Create user profiles and authentication setup
-- Description: Sets up user_profiles table with RLS policies for EverMynd backend
-- Author: Claude Code
-- Date: 2025-09-02

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create user_profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    roles TEXT[] DEFAULT ARRAY['Consumer'],
    subscription_status TEXT DEFAULT 'free' CHECK (subscription_status IN ('free', 'premium', 'enterprise')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_subscription_status ON user_profiles(subscription_status);

-- Enable Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (for re-running migration)
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Service role can manage all profiles" ON user_profiles;
DROP POLICY IF EXISTS "Allow authenticated users to insert their own profile" ON user_profiles;

-- Policy: Users can view their own profile
CREATE POLICY "Users can view their own profile" ON user_profiles
    FOR SELECT 
    USING (auth.uid() = user_id);

-- Policy: Users can update their own profile  
CREATE POLICY "Users can update their own profile" ON user_profiles
    FOR UPDATE 
    USING (auth.uid() = user_id);

-- Policy: Allow authenticated users to insert their own profile
CREATE POLICY "Allow authenticated users to insert their own profile" ON user_profiles
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Policy: Service role can manage all profiles (for admin operations)
CREATE POLICY "Service role can manage all profiles" ON user_profiles
    FOR ALL 
    USING (auth.role() = 'service_role');

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at
DROP TRIGGER IF EXISTS update_user_profiles_updated_at ON user_profiles;
CREATE TRIGGER update_user_profiles_updated_at 
    BEFORE UPDATE ON user_profiles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Create function to automatically create user profile after user signup
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.user_profiles (user_id, display_name, roles, subscription_status)
    VALUES (
        NEW.id, 
        COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)), 
        ARRAY['Consumer'], 
        'free'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create profile for new users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON public.user_profiles TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;

-- Insert a comment for migration tracking
COMMENT ON TABLE user_profiles IS 'User profiles table for EverMynd backend - Created by migration 001';