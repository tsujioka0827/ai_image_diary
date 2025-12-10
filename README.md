# ai_image_diary

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🏗️ システム構成図 (System Architecture)

```mermaid
graph TD
    %% クライアント側
    Client[Flutterアプリ]

    %% AWSクラウド側
    subgraph AWS_Cloud ["AWS Cloud (Serverless Architecture)"]
        direction TB
        
        %% 1. 認証
        Cognito[Amazon Cognito]
        
        %% 2. API & DB
        AppSync["AWS AppSync<br>GraphQL API"]
        DynamoDB[("Amazon DynamoDB<br>NoSQL Database")]
        
        %% 3. ストレージ
        S3[("Amazon S3<br>Object Storage")]
        
        %% 4. AI処理
        Lambda["AWS Lambda<br>Function"]
        Bedrock["Amazon Bedrock<br>Generative AI"]
    end

    %% データフローの線
    Client -->|1. ユーザー認証| Cognito
    Client -->|2. 日記データの送受信| AppSync
    Client -->|3. 画像のダウンロード| S3

    %% 内部連携
    AppSync <-->|データの読み書き| DynamoDB
    AppSync -->|画像生成トリガー| Lambda
    Lambda -->|プロンプト送信| Bedrock
    Bedrock -->|画像データ返却| Lambda
    Lambda -->|画像ファイル保存| S3
    Lambda -->|保存先URLを記録| DynamoDB
    
    %% 色の設定
    style AWS_Cloud fill:#fff,stroke:#232f3e,stroke-width:2px
    style Cognito fill:#de3e3e,stroke:#fff,color:#fff
    style AppSync fill:#de3e3e,stroke:#fff,color:#fff
    style DynamoDB fill:#3b48cc,stroke:#fff,color:#fff
    style S3 fill:#24882c,stroke:#fff,color:#fff
    style Lambda fill:#d86613,stroke:#fff,color:#fff
    style Bedrock fill:#24882c,stroke:#fff,color:#fff
    style Client fill:#eee,stroke:#333
```
