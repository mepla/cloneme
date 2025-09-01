#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Landing Page Deployment Script${NC}"
echo "================================="

# Check if nvm is available and switch to Node.js 22
if command -v nvm &> /dev/null; then
    echo -e "${YELLOW}🔧 Switching to Node.js 22...${NC}"
    source ~/.nvm/nvm.sh
    nvm use 22
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to switch to Node.js 22. Please install Node.js 22 first:${NC}"
        echo "nvm install 22"
        exit 1
    fi
    echo -e "${GREEN}✅ Using Node.js version: $(node --version)${NC}"
elif [ -f ~/.nvm/nvm.sh ]; then
    echo -e "${YELLOW}🔧 Loading nvm and switching to Node.js 22...${NC}"
    source ~/.nvm/nvm.sh
    nvm use 22
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to switch to Node.js 22. Please install Node.js 22 first:${NC}"
        echo "nvm install 22"
        exit 1
    fi
    echo -e "${GREEN}✅ Using Node.js version: $(node --version)${NC}"
else
    echo -e "${YELLOW}⚠️  nvm not found. Using system Node.js: $(node --version)${NC}"
    # Check if we have at least Node.js 20
    node_version=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$node_version" -lt 20 ]; then
        echo -e "${RED}❌ Node.js version 20+ required. Current version: $(node --version)${NC}"
        exit 1
    fi
fi

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found. Make sure you're in the landing_page directory.${NC}"
    exit 1
fi

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Error: Firebase CLI not found. Please install it first:${NC}"
    echo "npm install -g firebase-tools"
    exit 1
fi

echo -e "${YELLOW}📦 Building the project...${NC}"
npm run build

# Check if build was successful
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed. Please fix the errors and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build completed successfully!${NC}"

# Check if dist directory exists
if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Error: dist directory not found after build.${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}🔍 Build output:${NC}"
ls -la dist/

echo ""
echo -e "${YELLOW}🚀 Ready to deploy to Firebase Hosting${NC}"
echo ""
echo "Deploy options:"
echo "1) Deploy to production (live)"
echo "2) Deploy to preview channel"
echo "3) Cancel deployment"
echo ""

while true; do
    read -p "Choose an option (1-3): " choice
    case $choice in
        1)
            echo -e "${YELLOW}🚀 Deploying to production...${NC}"
            firebase deploy --only hosting
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Successfully deployed to production!${NC}"
            else
                echo -e "${RED}❌ Production deployment failed.${NC}"
                exit 1
            fi
            break
            ;;
        2)
            read -p "Enter preview channel name (default: preview): " channel
            channel=${channel:-preview}
            echo -e "${YELLOW}🚀 Deploying to preview channel: $channel${NC}"
            firebase hosting:channel:deploy $channel
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Successfully deployed to preview channel: $channel${NC}"
            else
                echo -e "${RED}❌ Preview deployment failed.${NC}"
                exit 1
            fi
            break
            ;;
        3)
            echo -e "${YELLOW}⏹️  Deployment cancelled.${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option. Please choose 1, 2, or 3.${NC}"
            ;;
    esac
done

echo ""
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"