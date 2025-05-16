# サービス名：お散歩マップ
サービスURL:https://www.xn--t8jvn5b0a8338dmth.com/

## 目次
- [サービス概要](#サービス概要)
- [開発背景](#開発背景)
- [機能紹介](#機能紹介)
- [技術構成について](#使用技術)
  - [使用技術](#使用技術)
  - [ER図](#er図)
  - [画面遷移図](#画面遷移図)
- [今後の開発について](#今後の開発について)

## サービス概要
「お散歩マップ」は、散歩コースを作成・投稿できるサービスです。

またよりコースの作成・検索を楽しんでいただくため、以下の機能を今後実装していく予定です。
- スポット機能：コースの見どころやスポット (カフェや休憩場所など) を追加できます。
- タグ機能：テーマ (例：海岸沿い) に合わせたコースを検索することができます。

## 開発背景
私自身、散歩をすることで気分がリフレッシュし、地元の中にも新たな発見があることを実感することがあります。
このような経験を通じて、他の人がどのような場所を散歩しているのかが気になり、散歩コースを共有できるサービスを作りたいと思いました。
自分だけでなく、他の人が見つけた素敵な場所やコースに触れることで、散歩がさらに楽しくなるのではないかと思いました。

## 機能紹介
| ユーザー登録 / ログイン |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/2169ad7063e46d56e705107f2d270357.png)](https://gyazo.com/2169ad7063e46d56e705107f2d270357) |
| <p align="left">『ユーザーネーム』『メールアドレス』『パスワード』『確認用パスワード』を入力してユーザー登録を行います。ユーザー登録後は、自動的にログイン処理が行われるようになっており、そのまま直ぐにサービスを利用する事が出来ます。<br>また、Googleアカウントを用いてGoogleログインを行う事も可能です。</p> |

<br>

| コース検索 |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/1fa63c1b51c64c11bb2b19e5fa2ed739.gif)](https://gyazo.com/1fa63c1b51c64c11bb2b19e5fa2ed739) |
| <p align="left">地名やタイトルでコースを検索することができます。また、距離で見たいコースを絞り込むこともできます。</p> |

<br>

| コース作成 |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/03991fd18ddc1bbd7f991acfe75f88ef.gif)](https://gyazo.com/03991fd18ddc1bbd7f991acfe75f88ef) |
| <p align="left">マップ上をクリックしていくことで、任意のコースを作成することができます。</p> |

## 使用技術
| カテゴリ | 技術 |
| --- | --- | 
| バックエンド | Ruby 3.2.3 / Ruby on Rails 7.0.8 |
| フロントエンド | Ruby on Rails / JavaScript |
| CSSフレームワーク | Tailwindcss + daisyUI |
| データベース | PostgreSQL |
| 環境構築 | Docker |
| CI/CD | Github Actions |
| インフラ | Heroku / AWS S3 |
| Web API | Google API |

## ER図
dbdiagram:https://dbdiagram.io/d/6742dd75e9daa85aca81ae8f
[![Image from Gyazo](https://i.gyazo.com/71580c63a603dc392ba6b91ef5dbfc2a.png)](https://gyazo.com/71580c63a603dc392ba6b91ef5dbfc2a)

## 画面遷移図
Figma:https://www.figma.com/design/W2xsyZjZf25z0ACYPlbqHG/%E6%95%A3%E6%AD%A9%E3%82%B3%E3%83%BC%E3%82%B9%E6%8A%95%E7%A8%BF%E3%82%A2%E3%83%97%E3%83%AA?node-id=0-1&t=gEtpL6e3LhhTj3po-1

## 今後の開発について
今後、以下の機能を実装予定です。
- スポット機能
- ブックマーク機能
- コメント機能
- いいね機能
- マイページ
- タグ機能

[開発スタート時のREADMEはこちら](https://github.com/y-yany/PathFinder/pull/1)