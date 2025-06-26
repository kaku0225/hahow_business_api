# Hahow for Business Backend Engineer API

這是一個使用 **Ruby on Rails (API-only)** 與 **GraphQL** 架構之線上課程管理後台，提供「課程 (Course)」、「章節 (Section)」與「單元 (Unit)」的 CRUD 操作與巢狀管理。

## 目錄

* [前置需求](#前置需求)
* [安裝與啟動](#安裝與啟動)
* [資料庫設定](#資料庫設定)
* [啟動伺服器](#啟動伺服器)
* [測試](#測試)
* [專案結構](#專案結構)
* [API 架構](#api-架構)
* [GraphQL 使用範例](#graphql-使用範例)
* [第三方 Gems](#第三方-gems)
* [註解原則](#註解原則)
* [實作選擇理由](#實作選擇理由)
* [開發中遇到的困難與解法](#開發中遇到的困難與解法)

---

## 前置需求

* Ruby 2.7.4 或以上
* Rails 6.1 或以上
* PostgreSQL

---

## 安裝與啟動

1. **Clone 專案**

   ```bash
   git clone https://github.com/kaku0225/hahow_business_api
   cd hahow_business_api
   ```

2. **安裝 Gems**

   ```bash
   bundle install
   ```

3. **建立並遷移資料庫**

   ```bash
   rails db:create db:migrate
   ```

---

## 啟動伺服器

```bash
rails server -p 3000
# 啟動後，可前往 GraphiQL IDE: http://localhost:3000/graphiql
```

---

## 測試

```bash
bundle exec rspec
```

所有的 Query 與 Mutation 功能都有對應的 request spec，請確保綠燈再提交。

---

## 專案結構

```
.
├── app
│   ├── controllers
│   │   └── graphql_controller.rb      # GraphQL Endpoint
│   ├── graphql
│   │   ├── hahow_business_api_schema.rb
│   │   ├── mutations                  # Create/Update/Delete 定義
│   │   ├── types                      # GraphQL Types
│   │   └── types/inputs               # InputObject 定義
│   ├── models                         # ActiveRecord Models
│   └──
└── spec
    └── requests/graphql               # Query & Mutation 測試
```

---

## API 架構

* **單一 Endpoint**: `POST /graphql`
* **Schema**:

  * Query: `courses`, `course(id:)`
  * Mutation: `createCourse`, `updateCourse`, `deleteCourse`
* **巢狀 Attributes**: 透過 `accepts_nested_attributes_for` 一次建立/更新/刪除 Course→Section→Unit
* **排序管理**: 使用 `acts_as_list` 自動處理 `position`

---

## GraphQL 使用範例

### 取得所有課程

```graphql
query {
  courses {
    id
    name
    instructor
    description
    sections {
      id
      title
      position
      units {
        id
        title
        content
        position
      }
    }
  }
}
```

### 建立課程

```graphql
mutation($input: CreateCourseInput!) {
  createCourse(input: $input) {
    course {
      id
      name
      sections { id title units { id title } }
    }
    errors
  }
}
```

變數範例:

```json
{
  "input": {
    "courseAttributes": {
      "name": "GraphQL 實戰",
      "instructor": "Eason",
      "sectionsAttributes": [
        {
          "title": "Intro",
          "unitsAttributes": [
            { "title": "What is GraphQL", "content": "GraphQL 是…" }
          ]
        }
      ]
    }
  }
}
```

---

## 第三方 Gems

* **graphql**: 定義 Schema、Types、Queries、Mutations。
* **graphiql-rails**: 提供開發時的 GraphiQL Playground。
* **rspec-rails**: Rails 測試框架。
* **factory\_bot\_rails** & **faker**: 測試資料建立。
* **acts\_as\_list**: List 排序管理，根據 `position` 自動處理順序。

---

## 註解原則

1. **商業邏輯**：複雜的 nested attribute 處理、排序邏輯需加註解。
2. **公共 Interface**：GraphQL Resolver、Mutation 有說明參數用途。

---

## 實作選擇理由

* **GraphQL**：單一 endpoint，可客製巢狀資料，減少 round-trip。
* **Nested Attributes**：一次同步建立/更新/刪除 Course→Section→Unit，降低 client 邏輯。
* **acts\_as\_list**：自動管理 `position`，不用自己寫排序 callback。
* **class-based Mutations**：一致的 `input` / `payload` pattern，易於擴充。

---

## 開發中遇到的困難與解法

1. **GraphQL Input 包裝**：Mutation 必須用 `input` 參數，Fixture 需改成 `CreateCourseInput`。
2. **Hash Key 類型差異**：在 `resolve` 裡同時處理 Symbol / String key (`attrs.delete(:id) || attrs.delete('id')`)。

---

> 若有其他問題或需求，歡迎在 Slack channel 中隨時討論！
