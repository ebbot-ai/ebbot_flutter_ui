# Errors

## Success

| HTTPS Code | Status     | Description                                      |
| ---------- | ---------- | ------------------------------------------------ |
| 200        | OK         | Successful request.                              |
| 201        | Created    | Successful request, content was created.         |
| 200        | No Content | Successful request, no content will be returned. |

## Errors

Most error responses from the API will include a Message or Description property with more details of what went wrong.

### Client

| HTTPS Code | Status                 | Description                                                                                                                                                     |
| ---------- | ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 400        | Bad request            | Something in the request is missing or wrong.                                                                                                                   |
| 401        | Unauthorized           | Authentication failed.                                                                                                                                          |
| 403        | Forbidden              | The request is correct but cannot be performed.                                                                                                                 |
| 404        | Not found              | Resource not found.                                                                                                                                             |
| 405        | Method not allowed     | The method specified is not allowed for the resource.                                                                                                           |
| 406        | Not Acceptable         | Content generated is not matched with the Accept header.                                                                                                        |
| 411        | Length Required        | Content-Length header is missing or wrong.                                                                                                                      |
| 415        | Unsupported Media Type | Content-Type header is missing or wrong.                                                                                                                        |
| 429        | Too many requests      | Too many requests within the specified time slot. The HTTP header Retry-After specifies the number of seconds to wait before the next POST request can be made. |

### Server errors

| HTTPS Code | Status                | Description                                                              |
| ---------- | --------------------- | ------------------------------------------------------------------------ |
| 500        | Internal Server Error | Server could not process the request due to internal error.              |
| 502        | Bad Gateway           | Invalid response or could not reach upstream server or application pool. |
| 503        | Service unavailable   | Server is currently unavailable or down for maintenance.                 |

