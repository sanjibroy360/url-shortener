# URL Shortener API

A RESTful API for creating shortened URLs.

## Demo Video

[https://www.loom.com/share/b02c7975f59944ed8a6204ff5a63d608?sid=7dfb99c8-d49a-45ed-9481-4a4cc5dfcc52](https://www.loom.com/share/b02c7975f59944ed8a6204ff5a63d608?sid=7dfb99c8-d49a-45ed-9481-4a4cc5dfcc52)

## 🛠️ Tech Stack

- **Ruby on Rails 7+**
- **Ruby 3.2.4**

## ⚙️ Installation

Want to check out the project on your own machine? Here's how you can get started:

1. **Clone the repository**

```bash
git git@github.com:sanjibroy360/url-shortener.git
```

2. **Navigate to the Project Directory**

```bash
cd url-shortener
```

3. **Install Dependencies**

```bash
bundle install
```

4. **Set Up the Database**

```bash
rails db:create
rails db:migrate
```

5. **Start the Rails Server**

```bash
rails server
```

## APIs

### Get all shortened URLs

- Endpoint: `http://localhost:3000/urls` **[GET]**

### Create shortened URL

- Endpoint: `http://localhost:3000/urls` **[POST]**
- Demo payload:

```ruby
    {
      url: {
        long_url: 'https://sanjibroy.com'
      }
    }
```

### Delete any shortened URL

- Endpoint: `http://localhost:3000/urls/:short_code` **[GET]**

### Visit any shortened URL

- Endpoint: `http://localhost:3000/:short_code` **[GET]**
