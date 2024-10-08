## アプリケーション名

しりとり画像ジェネレーター（Word Chain Image Generator）

## アプリケーション概要

ローマ字タイピングの練習ができるアプリケーションです。
しりとりの結果をプロンプトとして画像生成を行い、どんな画像ができるかを楽しみながらローマ字タイピングの習得に取り組むことができます。
画像生成機能が興味・動機づけとなり、プロンプトとなるしりとりをタイピング形式で行うことで結果的にローマ字タイピングの練習につながります。

## URL

https://word-chain-image-generator.onrender.com/

## 利用方法

- しりとりの単語をローマ字タイピングで入力し登録
- 5 単語以上しりとりを続けて［画像生成］ボタンをクリックするとしりとり結果に応じた画像が生成される
- 詳細はトップページ内の［あそびかた］を参照
- ローマ字入力方法を確認したい場合は［ローマ字表］を参照
- スマートフォンなどのデバイスは仮想キーボードでタイピング可能
- ゲストモード（未ログイン）：
  - マイページアクセス以外の全ての機能が利用可能
- 登録ユーザー：
  - マイページ一覧（作品履歴）が参照可能
  - マイページ上で作品の削除が可能

## アプリケーションを開発した背景

2020 年より小学生から対象にラップトップ端末が貸与され幼少期から IT リテラシーが求められる時代になりました。
PC を扱うためには基本的なキーボードタイピングが必要で、我が子に対し早いうちからキーボードタイピングを覚えさせることが大切だと考える親御さんも多くいます。
実際に私の長女がローマ字タイピングの習得ができず、かと言って「練習するのもつまらない！ローマ字も覚えたくない！！」
といった課題を抱えておりました...
ローマ字そのものを教えることはできるがなんとか主体的に学習につながる環境づくりをサポートできないか。
といった考えから **`子供たちがローマ字入力でのキーボードタイピングを習得しやすく、楽しく学べる環境を提供してITリテラシー向上のきっかけになることで世の中への貢献になれば`** という想いで企画、開発に至りました。

## 参考イメージ

|                                            物理キーボードからローマ字入力でしりとりの単語を登録                                             |
| :-----------------------------------------------------------------------------------------------------------------------------------------: |
| <img alt="物理キーボードからローマ字入力でしりとりの単語を登録" src="https://i.gyazo.com/cf4daab656a3820902404d5fb9f7b555.gif" width="400"> |

|                                            仮想キーボードから入力（タイピングミスのパターン）                                             |
| :---------------------------------------------------------------------------------------------------------------------------------------: |
| <img alt="仮想キーボードから入力（タイピングミスのパターン）" src="https://i.gyazo.com/7d018e6ba54f49f52b253796667ebe8b.gif" width="400"> |

|                             画像生成例（2〜3 分かかる場合があります）                             |
| :-----------------------------------------------------------------------------------------------: |
| <img alt="画像生成例" src="https://i.gyazo.com/8d61e388494a5e147d5244ea3fa6bb30.jpg" width="400"> |

|                                            遊び方のモーダルナビゲーションとローマ字表                                             |
| :-------------------------------------------------------------------------------------------------------------------------------: |
| <img alt="遊び方のモーダルナビゲーションとローマ字表" src="https://i.gyazo.com/f81676330a734e1b7938731778390889.gif" width="400"> |

## 実装予定の機能

- ~~ユーザー管理機能（ペルソナが小学校低学年のため MVP リリースの段階では実装を劣後しました）~~<br> => 4/21 実装完了

- スコアリング機能（しりとりを続けたくなる要素＝タイピング練習につながる要素として検討）
- 制限時間機能（ゲーム性を高める目的ですが、ペルソナ（小学校低学年）に対しては楽しめなくなる要素の可能性が高いため難易度選択の追加要素として検討）

## データベース設計

<img src="https://i.gyazo.com/7a18c1aa801f3c14f73fbb6690634d05.png" width="400">

### users テーブル

| Column             | Type    | Options                   |
| ------------------ | ------- | ------------------------- |
| id(PK)             | integer | null: false               |
| name               | string  | null: false               |
| email              | string  | null: false, unique: true |
| password           | string  | null: false               |
| encrypted_password | string  | null: false               |

### Association

- has_many :image_generates

### image_generates テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| id(PK)         | integer    | null: false                    |
| word_chain     | text       | null: false                    |
| prompt         | text       | null: false                    |
| http_status    | integer    | null: false                    |
| generate_model | string     | null: false                    |
| user(FK)       | references | null: false, foreign_key: true |

### Association

- belongs_to :user

## 画面遷移図

画面遷移図<a href="https://www.figma.com/file/xceBQ2SCIA4s3EqM3rXzjZ/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3%EF%BC%9A%E3%81%97%E3%82%8A%E3%81%A8%E3%82%8A%E7%94%BB%E5%83%8F%E3%82%B8%E3%82%A7%E3%83%8D%E3%83%AC%E3%83%BC%E3%82%BF%E3%83%BC?type=design&node-id=0%3A1&mode=design&t=2WVdNl7NoeX5l6fe-1">（外部リンク）</a>

## 開発環境

| カテゴリ                       | 技術内容                                                                                                                         |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| フロントエンド                 | HTML/CSS<br>Tailwind CSS<br>JavaScript                                                                                           |
| バックエンド                   | Ruby 3.2.0<br>Rails 7.0.8.1<br>PostgreSQL 14.10                                                                                  |
| インフラ                       | Render                                                                                                                           |
| ファイルストレージ             | AWS S3                                                                                                                           |
| API                            | StableDiffusion API（Hugging Face）<br>OpenAI API（DALL-E3）<br>GAS 翻訳 API（自作）<br>Twitter API<br>Tiny_URL（短縮 URL 生成） |
| バージョン管理                 | Git/GitHub                                                                                                                       |
| CI/CD                          | CI：GitHub Actions<br>CD：Render                                                                                                 |
| ワイヤーフレーム<br>画面遷移図 | Figma                                                                                                                            |
| ER 図                          | drow.io                                                                                                                          |
| アナリティクス                 | Google Analytics                                                                                                                 |

## ローカルでの動作方法

※ 画像生成をするために別途 Hugging Face で API Key を取得し **`STABLE_DIFFUSION_API_KEY`** として環境変数化が必要です。
API 取得方法は以下リンクへアクセスし「 **`Stable DiffusionのAPI取得方法`** 」の見出し（1）を参照ください。
https://zenn.dev/no215/articles/9490defad6948b

```zsh:ターミナル
% git clone
% cd
% bundle install
% vim ~/.zshrc
% source ~/.zshrc
```

## 工夫したポイント

- レスポンシブ対応するために仮想キーボードを導入しました。PC を携行しない外出時でもスマートフォンでローマ字タイピング入力ができます。
- ローマ字をすぐに確認できるようにモーダル形式でローマ字表を実装しました。
- 画像生成のリクエスト制限（429 エラー）やサーバーエラー（500, 503）の対策として指数バックオフ方式（2 秒〜32 秒、最大 5 回）でリトライを行うロジックにしました。<br>また、429 エラーの場合は別の生成モデルの API へフォールバックする仕様とし、画像生成の安定性向上に努めました。
- ペルソナ（小学校低学年）に向けては不要な機能ですが、サービスのユーザースケールを目的として SNS（X）へのシェア機能を実装しました。
- 画像生成機能において適切な生成 AI モデルを選択し、ネガティブプロンプトをあらかじめ組み込むことで極力不適切な画像を生成させない仕様としました。
- しりとりのルールにおける拗音（「しゃ」など）や長音（「ー」）または拗音＋長音（「シャー」など）で単語が終わる場合の次の単語の頭文字の扱いに配慮しました。（例：「ゃ」で始まる単語を求めない）
- テストコード実装においてテストのたびに画像生成 API を叩く処理をエミュレートし外部 API による依存を制御することでテストの安定性を向上させました。

## 改善点

- ~~画像生成に関してリクエスト制限対策を講じたい。Stable Diffusion のレート制限に達した場合は代替先となる別の API へリクエストを行うことで画像生成エラーの可能性を減らし UX 向上に繋げたい。~~<br> => DALL-E3 を導入しレート制限に起因するエラーハンドリングを行いました。（4/11 実装完了）
- ~~画像生成に使用するプロンプトとして不適切な単語を排除することでアプリケーションの信頼性と安全性を高めたい。~~<br> => GAS で指定ワードフィルター API を作成し不適切な単語を画像生成プロンプトから排除する仕様としました。（4/10 実装完了）

## 制作時間

- 2024 年 4 月 1 日時点でトータル 105 時間
  - MVP リリースで 50 時間ほど
  ### MVP リリース時点での実装機能
  - タイピング機能
    - タイピング正誤判定
    - 仮想キーボード実装
    - 物理キーボードとの連動
  - しりとり機能
    - 既出単語の判定
    - 頭文字の正誤判定
  - 画像生成機能
