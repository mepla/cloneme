read the .ai_coding/plans/backend_implementation_plan.md and do the following:

* DO NOT IN ANY CIRCUMSTANCE WRITE OR CHANGE CODE, ONLY PLAN AND WRITE SPECS AT THIS POINT.
* Think really heard for this.
* Make these changes to the data types and databsed tables:
  * Creator is not a separate entity than User. A User have a list of known roles: Admin, Consumer, Creator. All users can become creators if they want.
  * Users progress and preferences will be store in their own knowledge graph using Graphiti, there is no need for learning_goals, interests, engagement_level and progress_level
  * It must be possible to provide real time ingesting progress for creators on their dashboard 
  * If there is a need for LLMs, we will always use OpenAI, no need for Anthropic.
  * Supabase service_key is not recommended anymore, consult the Supabase MCP and use a better approach