# Authentication

Each request should include auth header with the key `x-api-key` followed by your private token

## Auth header

```bash
POST /sms/v1 HTTP/1.1
Host: api.ebbot.ai
x-api-key: xxxx
Content-Type: application/json
```

### 401 Unauthorized

Will be returned if your credentials are wrong or you have insufficient privileges.

