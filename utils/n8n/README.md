# YouTube Creator Finder N8n Workflow

This N8n workflow searches YouTube for creators in specific topics and finds those with 100,000+ subscribers, then attempts to extract their contact information.

## Features

- **YouTube Search**: Searches YouTube for videos on specified topics
- **Channel Analysis**: Retrieves channel details and subscriber counts
- **Subscriber Filtering**: Filters channels with 100k+ subscribers
- **Contact Extraction**: Scrapes channel about pages for email addresses and social links
- **Data Formatting**: Provides structured output with contact information

## Prerequisites

### 1. YouTube Data API v3 Key
You need a Google Cloud Platform account and YouTube Data API v3 key:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable YouTube Data API v3
4. Create credentials (API Key)
5. Set the API key as environment variable `YOUTUBE_API_KEY` in N8n

### 2. N8n Environment Variables
Set the following environment variable in your N8n instance:
```
YOUTUBE_API_KEY=your_youtube_api_key_here
```

## Installation

1. Import the workflow JSON file (`youtube-creator-finder-workflow.json`) into your N8n instance
2. Configure the YouTube API key environment variable
3. Test the workflow with a manual trigger

## Usage

### Manual Trigger
The workflow starts with a manual trigger. You can customize the search topic by modifying the pinned data:

```json
{
  "searchTopic": "your search topic here"
}
```

### Search Topics Examples
- "programming tutorials"
- "cooking recipes"
- "fitness training"
- "digital marketing"
- "music production"

## Workflow Structure

1. **Manual Trigger**: Starts the workflow with search parameters
2. **YouTube Search**: Calls YouTube Data API to search for videos
3. **Extract Channel IDs**: Processes search results to get unique channel IDs
4. **Get Channel Details**: Retrieves channel statistics and information
5. **Filter High Subscriber Channels**: Keeps only channels with 100k+ subscribers
6. **Scrape Channel About Page**: Downloads the channel's about page content
7. **Extract Contact Information**: Uses regex to find emails and social links
8. **Filter Channels with Emails**: Keeps only channels where emails were found
9. **Format Final Results**: Structures the output data
10. **Create Search Summary**: Provides summary statistics

## Output Format

### Channel Results
```json
{
  "rank": 1,
  "channelInfo": {
    "title": "Channel Name",
    "subscribers": "250,000",
    "url": "https://www.youtube.com/channel/...",
    "channelId": "UC..."
  },
  "contactInfo": {
    "emails": ["business@example.com"],
    "socialLinks": ["https://twitter.com/username"],
    "businessInquiries": "For business inquiries contact...",
    "extractedContent": "Partial content from about page..."
  },
  "searchMetadata": {
    "extractedAt": "2025-01-02T00:00:00.000Z",
    "hasDirectEmail": true,
    "hasSocialLinks": true
  }
}
```

### Search Summary
```json
{
  "searchSummary": {
    "searchTopic": "programming tutorials",
    "timestamp": "2025-01-02T00:00:00.000Z",
    "channelsFound": 15,
    "totalEmailsFound": 12,
    "totalSocialLinksFound": 28,
    "successRate": "80%"
  },
  "topChannels": [...]
}
```

## API Limits & Considerations

### YouTube Data API v3 Limits
- **Quota**: 10,000 units per day (free tier)
- **Search**: 100 units per request
- **Channels**: 1 unit per request
- **Rate Limiting**: Consider adding delays between requests for large searches

### Web Scraping Considerations
- Some channels may block automated scraping
- Contact information extraction depends on how creators format their about pages
- Success rate varies by niche and creator practices

## Customization

### Modifying Search Parameters
Edit the "YouTube Search" node to change:
- `maxResults`: Number of videos to search (max 50)
- `order`: Sort order (relevance, date, viewCount, rating)
- `type`: Content type (video, channel, playlist)

### Adjusting Subscriber Threshold
Modify the filter condition in "Filter High Subscriber Channels":
```javascript
if (subscriberCount >= 100000) { // Change this number
```

### Email Extraction Patterns
Customize the regex pattern in "Extract Contact Information":
```javascript
const emailRegex = /\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b/g;
```

## Troubleshooting

### Common Issues

1. **API Key Invalid**: Verify your YouTube API key is correct and has proper permissions
2. **Quota Exceeded**: YouTube API has daily quotas - monitor your usage
3. **No Results**: Try different search terms or check if channels have public subscriber counts
4. **Scraping Failures**: Some channels may block automated requests

### Debugging Tips

- Check the execution log for HTTP request failures
- Verify API responses in the workflow execution data
- Test with a smaller `maxResults` value first
- Monitor rate limiting and add delays if needed

## Legal & Ethical Considerations

- **Respect robots.txt**: Be mindful of website scraping policies
- **Rate Limiting**: Don't overwhelm servers with too many requests
- **Privacy**: Use extracted contact information responsibly
- **YouTube ToS**: Ensure compliance with YouTube's Terms of Service
- **GDPR/Privacy Laws**: Handle personal data according to applicable laws

## Extensions

### Possible Enhancements
1. **Database Storage**: Store results in a database for persistence
2. **Email Validation**: Verify extracted emails are valid/active
3. **Social Media Scraping**: Extract more detailed social media information
4. **Notification System**: Send results via email or Slack
5. **Scheduling**: Run searches automatically on a schedule
6. **Export Options**: Export to CSV, Excel, or other formats

### Integration Ideas
- Connect to CRM systems for lead management
- Integrate with email marketing tools
- Link to social media management platforms
- Add to influencer marketing databases