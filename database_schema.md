# LIA (Love Intelligence Assistant) - Database Schema Plan

## Overview

LIA is a relationship analysis application that uses AI to analyze conversations between two people and provide insights about their relationship dynamics. This document outlines the database schema requirements and design for storing analysis data, user history, and relationship insights.

## Database Requirements

### Core Functionality
- Store complete relationship analysis results with nested data structures
- Track analysis history across multiple relationships
- Support time-series data for emotion trends and key events
- Enable efficient querying for charts and analytics
- Handle Korean language content
- Support JSON data structures for complex analysis results

### Technical Requirements
- **JSON Support**: Heavy use of nested JSON structures
- **Time-Series Queries**: Efficient time-based querying for trends
- **Full-Text Search**: Search through conversation content and tips
- **Aggregation**: Calculate statistics and trends
- **Caching Support**: Fast retrieval for frequently accessed data

## Database Design Options

### Option 1: PostgreSQL (Recommended)
**Pros:**
- Excellent JSON/JSONB support for nested data structures
- Robust time-series capabilities
- Full-text search with Korean language support
- Strong ACID compliance for data integrity
- Efficient indexing for complex queries

**Cons:**
- More complex setup than NoSQL alternatives
- Requires careful schema design for optimal performance

### Option 2: MongoDB
**Pros:**
- Native JSON document storage
- Flexible schema for evolving data models
- Good aggregation pipeline capabilities
- Easy horizontal scaling

**Cons:**
- Less mature Korean full-text search
- Potential consistency issues
- More complex relationship queries

## Supabase Database Schema (PostgreSQL)

### Core Tables for LLM Analysis Integration

#### 1. users (extends Supabase Auth)
```sql
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email VARCHAR(255),
    display_name VARCHAR(100),
    user_mbti VARCHAR(4),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    settings JSONB DEFAULT '{}'::jsonb
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
```

#### 2. relationship_analyses
Primary table storing complete LLM analysis results
```sql
CREATE TABLE public.relationship_analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    -- Basic Analysis Info (from LLM JSON)
    analysis_title VARCHAR(200) NOT NULL,
    partner_name VARCHAR(100) NOT NULL,
    conversation_period VARCHAR(50), -- e.g., "21일"
    conversation_start_date DATE,
    conversation_end_date DATE,
    
    -- LLM Analysis Results (full JSON storage)
    llm_response JSONB NOT NULL, -- Complete LLM response
    llm_model VARCHAR(50) NOT NULL, -- e.g., "gemini2.5pro", "gpt4o"
    
    -- Quick Access Fields (extracted from JSON)
    some_index INTEGER CHECK (some_index >= 0 AND some_index <= 100),
    development_possibility INTEGER CHECK (development_possibility >= 0 AND development_possibility <= 100),
    compatibility_score INTEGER CHECK (compatibility_score >= 0 AND compatibility_score <= 100),
    overall_emotion_score INTEGER CHECK (overall_emotion_score >= 0 AND overall_emotion_score <= 100),
    
    -- Partner Analysis
    partner_mbti VARCHAR(4),
    my_mbti VARCHAR(4),
    communication_style TEXT,
    ai_summary TEXT,
    
    -- Metadata
    total_messages INTEGER DEFAULT 0,
    analysis_confidence INTEGER CHECK (analysis_confidence >= 0 AND analysis_confidence <= 100),
    analysis_status VARCHAR(20) DEFAULT 'completed' CHECK (analysis_status IN ('pending', 'processing', 'completed', 'failed')),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    analyzed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.relationship_analyses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own analyses" ON public.relationship_analyses FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own analyses" ON public.relationship_analyses FOR INSERT WITH CHECK (auth.uid() = user_id);
```

#### 3. emotion_data_points
Time-series data extracted from LLM emotionAnalysis.emotionData
```sql
CREATE TABLE public.emotion_data_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    analysis_id UUID REFERENCES public.relationship_analyses(id) ON DELETE CASCADE,
    
    time_period VARCHAR(50) NOT NULL, -- e.g., "1주차", "2주차", "3주차"
    my_emotion_score INTEGER CHECK (my_emotion_score >= 0 AND my_emotion_score <= 100),
    partner_emotion_score INTEGER CHECK (partner_emotion_score >= 0 AND partner_emotion_score <= 100),
    description TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.emotion_data_points ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own emotion data" ON public.emotion_data_points FOR SELECT 
USING (auth.uid() IN (SELECT user_id FROM public.relationship_analyses WHERE id = analysis_id));
```

#### 4. analysis_key_events
Significant events extracted from LLM emotionAnalysis.keyEvents
```sql
CREATE TABLE public.analysis_key_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    analysis_id UUID REFERENCES public.relationship_analyses(id) ON DELETE CASCADE,
    
    event_time VARCHAR(50) NOT NULL, -- e.g., "2025-06-03 18:04"
    event_title VARCHAR(200) NOT NULL,
    event_type VARCHAR(20) NOT NULL CHECK (event_type IN ('positive', 'negative', 'neutral', 'peak')),
    description TEXT,
    score_impact VARCHAR(20), -- e.g., "+20%", "95%"
    color VARCHAR(20), -- UI color indicator
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.analysis_key_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own key events" ON public.analysis_key_events FOR SELECT 
USING (auth.uid() IN (SELECT user_id FROM public.relationship_analyses WHERE id = analysis_id));
```

#### 5. conversation_topics
Topic analysis extracted from LLM topicAnalysis
```sql
CREATE TABLE public.conversation_topics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    analysis_id UUID REFERENCES public.relationship_analyses(id) ON DELETE CASCADE,
    
    category VARCHAR(100) NOT NULL, -- e.g., "IT/개발", "재테크/주식"
    percentage INTEGER CHECK (percentage >= 0 AND percentage <= 100),
    examples TEXT[], -- Array of example topics
    color VARCHAR(20), -- UI color
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.conversation_topics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own topics" ON public.conversation_topics FOR SELECT 
USING (auth.uid() IN (SELECT user_id FROM public.relationship_analyses WHERE id = analysis_id));
```

#### 6. ai_recommendations
AI suggestions extracted from LLM aiRecommendations
```sql
CREATE TABLE public.ai_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    analysis_id UUID REFERENCES public.relationship_analyses(id) ON DELETE CASCADE,
    
    recommendation_type VARCHAR(50) NOT NULL, -- e.g., "immediateActions", "conversationStarters", "improvementTips"
    title VARCHAR(200),
    description TEXT,
    priority VARCHAR(20), -- e.g., "높음", "보통"
    category VARCHAR(100), -- e.g., "미래 비전", "기술 트렌드"
    sample_message TEXT,
    color VARCHAR(20),
    expected_outcome TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.ai_recommendations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own recommendations" ON public.ai_recommendations FOR SELECT 
USING (auth.uid() IN (SELECT user_id FROM public.relationship_analyses WHERE id = analysis_id));
```

#### 7. analyzed_people_history
Track history of analyzed relationships
```sql
CREATE TABLE public.analyzed_people_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    partner_name VARCHAR(100) NOT NULL,
    relationship_stage VARCHAR(100), -- e.g., "최고의 동료이자 찐친"
    
    -- Statistics
    total_analyses INTEGER DEFAULT 1,
    latest_analysis_id UUID REFERENCES public.relationship_analyses(id),
    first_analysis_date DATE,
    latest_analysis_date DATE,
    
    -- Quick access metrics from latest analysis
    latest_some_index INTEGER,
    latest_development_possibility INTEGER,
    latest_compatibility_score INTEGER,
    average_compatibility_score DECIMAL(5,2),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, partner_name)
);

-- Enable RLS
ALTER TABLE public.analyzed_people_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own history" ON public.analyzed_people_history FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can upsert own history" ON public.analyzed_people_history FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own history" ON public.analyzed_people_history FOR UPDATE USING (auth.uid() = user_id);
```

### Indexes for Performance

```sql
-- Primary performance indexes
CREATE INDEX idx_relationship_analyses_user_created ON public.relationship_analyses(user_id, created_at DESC);
CREATE INDEX idx_emotion_data_points_analysis ON public.emotion_data_points(analysis_id);
CREATE INDEX idx_key_events_analysis ON public.analysis_key_events(analysis_id);
CREATE INDEX idx_analyzed_people_user_updated ON public.analyzed_people_history(user_id, updated_at DESC);

-- JSON indexes for LLM response queries
CREATE INDEX idx_relationship_analyses_llm_response ON public.relationship_analyses USING GIN (llm_response);
CREATE INDEX idx_relationship_analyses_some_index ON public.relationship_analyses(some_index DESC);
CREATE INDEX idx_relationship_analyses_compatibility ON public.relationship_analyses(compatibility_score DESC);

-- Full-text search indexes for Korean content
CREATE INDEX idx_relationship_analyses_search ON public.relationship_analyses USING GIN (to_tsvector('korean', analysis_title));
CREATE INDEX idx_key_events_search ON public.analysis_key_events USING GIN (to_tsvector('korean', event_title || ' ' || COALESCE(description, '')));
CREATE INDEX idx_ai_recommendations_search ON public.ai_recommendations USING GIN (to_tsvector('korean', title || ' ' || COALESCE(description, '')));

-- Partner name search
CREATE INDEX idx_analyzed_people_partner_name ON public.analyzed_people_history(user_id, partner_name);
```

## Supabase Database Schema Diagram

```
┌─────────────────────┐    ┌─────────────────────┐
│   auth.users        │    │   public.profiles   │
│   (Supabase Auth)   │    │                     │
│                     │◄───┤ id (FK)            │
│ id (PK)             │    │ email               │
│ email               │    │ display_name        │
│ created_at          │    │ user_mbti           │
└─────────────────────┘    │ settings (JSONB)    │
                           └──────────┬──────────┘
                                      │
                                      │ 1:N
                                      │
                           ┌──────────▼──────────────────────┐
                           │ public.relationship_analyses    │
                           │                                 │
                           │ id (PK)                         │
                           │ user_id (FK)                    │
                           │ partner_name                    │
                           │ llm_response (JSONB)            │
                           │ llm_model                       │
                           │ some_index                      │
                           │ development_possibility         │
                           │ compatibility_score             │
                           │ partner_mbti                    │
                           │ ai_summary                      │
                           └──────────┬──────────────────────┘
                                      │
                                      │ 1:N (LLM data breakdown)
                                      │
        ┌──────────┬──────────────────┼──────────────────┬──────────────┐
        │          │                  │                  │              │
        ▼          ▼                  ▼                  ▼              ▼
┌───────────┐ ┌───────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│emotion_   │ │analysis_  │ │conversation_│ │ai_          │ │analyzed_    │
│data_points│ │key_events │ │topics       │ │recommendations│ │people_      │
│           │ │           │ │             │ │             │ │history      │
│id (PK)    │ │id (PK)    │ │id (PK)      │ │id (PK)      │ │id (PK)      │
│analysis_id│ │analysis_id│ │analysis_id  │ │analysis_id  │ │user_id (FK) │
│  (FK)     │ │  (FK)     │ │  (FK)       │ │  (FK)       │ │partner_name │
│time_period│ │event_time │ │category     │ │recommendation│ │relationship_│
│my_emotion │ │event_title│ │percentage   │ │  _type      │ │  stage      │
│partner_   │ │event_type │ │examples[]   │ │title        │ │total_       │
│ emotion   │ │description│ │color        │ │description  │ │ analyses    │
│description│ │score_     │ │             │ │priority     │ │latest_some_ │
│           │ │ impact    │ │             │ │sample_      │ │ index       │
│           │ │color      │ │             │ │ message     │ │latest_      │
│           │ │           │ │             │ │expected_    │ │ compatibility│
│           │ │           │ │             │ │ outcome     │ │             │
└───────────┘ └───────────┘ └─────────────┘ └─────────────┘ └─────────────┘

                    🔒 All tables have RLS (Row Level Security) enabled
                    👤 Users can only access their own data
                    🚀 Optimized for LLM JSON response storage and querying
```

## LLM Integration Data Flow

### 1. LLM Analysis Processing Flow
```sql
-- 1. Insert main analysis record with full LLM JSON response
INSERT INTO public.relationship_analyses (
    user_id, analysis_title, partner_name, llm_response, llm_model,
    some_index, development_possibility, compatibility_score,
    partner_mbti, my_mbti, ai_summary, total_messages
) VALUES (
    auth.uid(),
    $1, -- analysis_title
    $2, -- partner_name
    $3, -- complete LLM JSON response
    $4, -- e.g., 'gemini2.5pro'
    ($3->>'basicAnalysis'->>'someIndex')::integer,
    ($3->>'basicAnalysis'->>'developmentPossibility')::integer,
    ($3->>'personalityAnalysis'->>'compatibilityScore')::integer,
    $3->>'basicAnalysis'->>'partnerMbti',
    $3->>'basicAnalysis'->>'myMbti',
    $3->>'basicAnalysis'->>'aiSummary',
    ($3->>'analysisMetadata'->>'totalMessages')::integer
) RETURNING id;

-- 2. Extract and insert emotion data points
INSERT INTO public.emotion_data_points (analysis_id, time_period, my_emotion_score, partner_emotion_score, description)
SELECT 
    $1, -- analysis_id
    value->>'time',
    (value->>'myEmotion')::integer,
    (value->>'partnerEmotion')::integer,
    value->>'description'
FROM jsonb_array_elements($2->'emotionAnalysis'->'emotionData') AS value;

-- 3. Extract and insert key events
INSERT INTO public.analysis_key_events (analysis_id, event_time, event_title, event_type, description, score_impact, color)
SELECT 
    $1, -- analysis_id
    value->>'time',
    value->>'event',
    value->>'type',
    value->>'description',
    value->>'score',
    value->>'color'
FROM jsonb_array_elements($2->'emotionAnalysis'->'keyEvents') AS value;

-- 4. Extract and insert conversation topics
INSERT INTO public.conversation_topics (analysis_id, category, percentage, examples, color)
SELECT 
    $1, -- analysis_id
    value->>'category',
    (value->>'percentage')::integer,
    ARRAY(SELECT jsonb_array_elements_text(value->'examples')),
    value->>'color'
FROM jsonb_array_elements($2->'topicAnalysis'->'topicFrequency') AS value;

-- 5. Extract and insert AI recommendations
INSERT INTO public.ai_recommendations (analysis_id, recommendation_type, title, description, priority, sample_message, expected_outcome, color)
SELECT 
    $1, -- analysis_id
    'immediateActions',
    value->>'title',
    value->>'description',
    value->>'priority',
    value->>'sampleMessage',
    value->>'expectedOutcome',
    value->>'color'
FROM jsonb_array_elements($2->'aiRecommendations'->'immediateActions') AS value;

-- 6. Upsert analyzed people history
INSERT INTO public.analyzed_people_history (
    user_id, partner_name, relationship_stage, total_analyses, 
    latest_analysis_id, latest_analysis_date,
    latest_some_index, latest_development_possibility, latest_compatibility_score
) VALUES (
    auth.uid(), $2, -- partner_name
    $3->>'aiRecommendations'->'relationshipStageAnalysis'->>'currentStage',
    1,
    $1, -- analysis_id
    CURRENT_DATE,
    ($3->>'basicAnalysis'->>'someIndex')::integer,
    ($3->>'basicAnalysis'->>'developmentPossibility')::integer,
    ($3->>'personalityAnalysis'->>'compatibilityScore')::integer
) ON CONFLICT (user_id, partner_name) 
DO UPDATE SET 
    total_analyses = analyzed_people_history.total_analyses + 1,
    latest_analysis_id = $1,
    latest_analysis_date = CURRENT_DATE,
    latest_some_index = ($3->>'basicAnalysis'->>'someIndex')::integer,
    latest_development_possibility = ($3->>'basicAnalysis'->>'developmentPossibility')::integer,
    latest_compatibility_score = ($3->>'personalityAnalysis'->>'compatibilityScore')::integer,
    average_compatibility_score = (
        analyzed_people_history.average_compatibility_score * analyzed_people_history.total_analyses + 
        ($3->>'personalityAnalysis'->>'compatibilityScore')::integer
    ) / (analyzed_people_history.total_analyses + 1);
```

### 2. Analysis Retrieval for Flutter App
```sql
-- Get complete analysis with all breakdown data
SELECT 
    ra.*,
    COALESCE(
        json_agg(DISTINCT jsonb_build_object(
            'time', edp.time_period,
            'myEmotion', edp.my_emotion_score,
            'partnerEmotion', edp.partner_emotion_score,
            'description', edp.description
        )) FILTER (WHERE edp.id IS NOT NULL), 
        '[]'
    ) as emotion_data,
    COALESCE(
        json_agg(DISTINCT jsonb_build_object(
            'time', ake.event_time,
            'event', ake.event_title,
            'type', ake.event_type,
            'description', ake.description,
            'score', ake.score_impact,
            'color', ake.color
        )) FILTER (WHERE ake.id IS NOT NULL),
        '[]'
    ) as key_events,
    COALESCE(
        json_agg(DISTINCT jsonb_build_object(
            'category', ct.category,
            'percentage', ct.percentage,
            'examples', ct.examples,
            'color', ct.color
        )) FILTER (WHERE ct.id IS NOT NULL),
        '[]'
    ) as conversation_topics,
    COALESCE(
        json_agg(DISTINCT jsonb_build_object(
            'type', ar.recommendation_type,
            'title', ar.title,
            'description', ar.description,
            'priority', ar.priority,
            'sampleMessage', ar.sample_message,
            'expectedOutcome', ar.expected_outcome,
            'color', ar.color
        )) FILTER (WHERE ar.id IS NOT NULL),
        '[]'
    ) as ai_recommendations
FROM public.relationship_analyses ra
LEFT JOIN public.emotion_data_points edp ON ra.id = edp.analysis_id
LEFT JOIN public.analysis_key_events ake ON ra.id = ake.analysis_id
LEFT JOIN public.conversation_topics ct ON ra.id = ct.analysis_id
LEFT JOIN public.ai_recommendations ar ON ra.id = ar.analysis_id
WHERE ra.id = $1 AND ra.user_id = auth.uid()
GROUP BY ra.id;

-- Get user's analysis history for main screen
SELECT 
    ra.id,
    ra.analysis_title,
    ra.partner_name,
    ra.some_index,
    ra.development_possibility,
    ra.compatibility_score,
    ra.ai_summary,
    ra.created_at,
    ra.llm_model
FROM public.relationship_analyses ra
WHERE ra.user_id = auth.uid()
ORDER BY ra.created_at DESC
LIMIT $1 OFFSET $2;

-- Get analyzed people history for "분석한 사람들" screen
SELECT 
    partner_name,
    relationship_stage,
    total_analyses,
    latest_some_index,
    latest_development_possibility,
    latest_compatibility_score,
    average_compatibility_score,
    latest_analysis_date
FROM public.analyzed_people_history
WHERE user_id = auth.uid()
ORDER BY latest_analysis_date DESC;
```

### 3. Chart Data Queries for Flutter Widgets
```sql
-- Emotion trend data for line chart
SELECT 
    time_period,
    my_emotion_score,
    partner_emotion_score
FROM public.emotion_data_points
WHERE analysis_id = $1
ORDER BY time_period;

-- Topic distribution for pie chart
SELECT 
    category,
    percentage,
    color
FROM public.conversation_topics
WHERE analysis_id = $1
ORDER BY percentage DESC;

-- Compatibility comparison radar chart data
SELECT 
    ra.partner_name,
    ra.compatibility_score,
    ra.some_index,
    ra.development_possibility,
    ra.overall_emotion_score
FROM public.relationship_analyses ra
WHERE ra.user_id = auth.uid()
ORDER BY ra.created_at DESC
LIMIT 5;
```

## Performance Considerations

### 1. Caching Strategy
- **Application-level caching**: Cache complete analysis results for 1 hour
- **Database-level caching**: Use materialized views for complex analytics
- **Redis integration**: Cache frequently accessed user history and statistics

### 2. Data Partitioning
- Partition `relationship_analyses` by creation date (monthly partitions)
- Partition `emotion_data_points` by analysis_id for better time-series performance

### 3. Archival Strategy
- Archive analyses older than 2 years to separate tables
- Implement soft deletes for user data compliance

## Security and Privacy

### 1. Data Encryption
- Encrypt sensitive conversation data in `analysis_data` JSONB field
- Use application-level encryption for personally identifiable information

### 2. Access Control
- Row-level security (RLS) policies to ensure users only access their data
- Audit logging for sensitive operations

### 3. Data Retention
- Implement configurable data retention policies
- Support user data export and deletion requests (GDPR compliance)

## Migration Strategy

### Phase 1: Core Tables
1. Create users and relationship_analyses tables
2. Migrate existing analysis data to JSONB format
3. Set up basic indexes

### Phase 2: Normalized Data
1. Create emotion_data_points and analysis_key_events tables
2. Extract time-series data from existing JSONB
3. Add performance indexes

### Phase 3: Advanced Features
1. Create personality_analyses and analysis_metadata tables
2. Implement full-text search capabilities
3. Add analytics and reporting functions

### Phase 4: Optimization
1. Implement partitioning strategies
2. Add caching layer
3. Performance tuning and monitoring

## Backup and Recovery

### 1. Backup Strategy
- Daily full database backups
- Point-in-time recovery capability
- Cross-region backup replication

### 2. Disaster Recovery
- Database clustering for high availability
- Automated failover procedures
- Regular recovery testing

This database schema provides a robust foundation for the LIA application, supporting complex relationship analysis data while maintaining performance and scalability.
