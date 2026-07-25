from twilio.rest import Client

account_sid = 'AC8b3167a893f635e1ee592187156acbc4'
auth_token = '[AuthToken]'
client = Client(account_sid, auth_token)

message = client.messages.create(
  from_='+12183578481',
  body='Hi Amr',
  to='+201003110848'
)

print(message.sid)

# 201 - CREATED - The request was successful. We created a new resource and the response body contains the representation.
res = {
  "account_sid": "AC8b3167a893f635e1ee592187156acbc4",
  "api_version": "2010-04-01",
  "body": "Sent from your Twilio trial account - Hi Amr",
  "date_created": "Thu, 06 Jun 2024 12:28:07 +0000",
  "date_sent": None,
  "date_updated": "Thu, 06 Jun 2024 12:28:07 +0000",
  "direction": "outbound-api",
  "error_code": None,
  "error_message": None,
  "from": "+12183578481",
  "messaging_service_sid": None,
  "num_media": "0",
  "num_segments": "1",
  "price": None,
  "price_unit": "USD",
  "sid": "SMfe43d3b24019bb67cfdfed754a7dd0d9",
  "status": "queued",
  "subresource_uris": {
    "media": "/2010-04-01/Accounts/AC8b3167a893f635e1ee592187156acbc4/Messages/SMfe43d3b24019bb67cfdfed754a7dd0d9/Media.json"
  },
  "to": "+201003110848",
  "uri": "/2010-04-01/Accounts/AC8b3167a893f635e1ee592187156acbc4/Messages/SMfe43d3b24019bb67cfdfed754a7dd0d9.json"
}