# Kekkai

**Kekkai IS SUSPENDED.**  
People from Twitter said they will support timeline data in AAAPI (at the forums), but they turned out not to. We are dead.

## What is _Kekkai_?

Kekkai is a service which converts the Account Activity API into streams.  
Kekkai provides your application its own Webhook URL.

## Why is this good?

To use the Account Activity API, you need to set up a server which implements man things,
including Webhook URL endpoints, HTTPS configuration, new AAAPI event type parsers, and so on.

By using Kekkai, you don't have to worry about the server-side. You can register with your Twitter account,
then Kekkai provides you an application-specific Webhook endpoint (which is secured by SSL),
so you just set that URL into your client settings.

## Help wanted

I want to have the option to keep the result stream as close as possible to the old UserStreams API.
But UserStreams API documents are solely gone now, so any documents about what the JSON formats were in UserStreams API
will help me. Thanks.

## Development

Kekkai is still under development. Feel free, any contributions are welcome, but I may do breaking things during the beta period.
