# AI Image Diary (AI画像分析日記)

## 📖 概要
撮影した写真をアップロードすると、AWSのAIが自動で「写っているもの（犬、海、料理など）」をタグ付けし、思い出を賢く整理できる日記アプリです。
第一希望の会社への入社を目指し、「AWS × Flutter」の実践的なポートフォリオとして開発しています。

## 🛠 使用技術

### モバイル (Flutter)
- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (予定)

### バックエンド (AWS)
- **Auth:** Amazon Cognito (ユーザー認証)
- **Storage:** Amazon S3 (画像保存)
- **Database:** Amazon DynamoDB
- **AI:** Amazon Rekognition (画像分析)

## 🚀 今後の開発ロードマップ
- [ ] プロジェクトの立ち上げとドキュメント作成
- [ ] UI作成（ログイン画面）
- [ ] AWS Cognito連携
- [ ] S3への画像アップロード


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
