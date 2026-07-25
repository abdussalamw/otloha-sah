# Chat

## Connect

to connect to the chat socket connect to the following url

```
ws://<domain>/ws/chat/:room_type/:room_uuid/?token=<access_token>
```

## Client Events

### Add message

* to create normal message send the following event

```json
{
  "type": "add_message",
  "message": {
    "text": "message text here",
    "reply_to": "<id: id of the message to reply to>",
    "record": "<id: id of the record>"
  }
}
```

* to create recitation message send the following event

```json
{
  "type": "add_message",
  "message": {
    "text": "message text here",
    "fault_type": "tajweed",
    "recitation": true,
    "error_text": "error text here",
    "position_from": "<int: start position of error text>",
    "position_to": "<int: end position of error text>"
  }
}
```

### Close Room

to close Room use the following event

```json
{
  "type": "close_room",
  "message": {}
}
```