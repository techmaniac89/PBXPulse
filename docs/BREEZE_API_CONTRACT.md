# Breeze API Contract

Breeze begins when PBXPulse starts breathing through an Agent.

The first Agent API should speak PBXPulse language, not Asterisk language. The
Flutter app asks for Home state and receives Signals, People, Calls, and Pulse
summary data.

## First Endpoints

```text
GET /home
WS  /live
```

Do not start with endpoints like:

```text
GET /pjsip/endpoints
GET /ami/events
```

Those are observer inputs, not app outputs.

## GET /home

`/home` returns the same concepts Genesis already uses locally.

```json
{
  "greeting": "Good evening",
  "mood": "Everything looks healthy.",
  "connection": {
    "kind": "local",
    "label": "Connected locally",
    "detail": "Your phone is reaching the PBXPulse Agent on this network.",
    "agentVersion": "0.1.0-breeze.0",
    "lastContact": "Just now"
  },
  "now": {
    "title": "Reception is talking to Maria.",
    "body": "Started 2 minutes ago.",
    "timeLabel": "Now",
    "isActive": true,
    "kind": "active"
  },
  "signals": [
    {
      "id": "sig_reception_maria",
      "kind": "call_answered",
      "category": "activity",
      "importance": "feed",
      "state": "active",
      "title": "Reception answered Maria.",
      "body": "Maria waited only a few seconds.",
      "timeLabel": "2 minutes ago",
      "actionLabel": null,
      "why": [
        "The call reached Reception.",
        "Reception answered before the caller waited long."
      ],
      "technical": {
        "channel": "PJSIP/101-00000042",
        "caller": "Maria",
        "extension": "101"
      }
    }
  ],
  "calls": [
    {
      "title": "Reception is talking to Maria.",
      "body": "Started 2 minutes ago.",
      "timeLabel": "Active now",
      "isActive": true,
      "kind": "active"
    }
  ],
  "people": [
    {
      "name": "Reception",
      "extension": "101",
      "status": "talking",
      "statusText": "On a call",
      "detail": "Talking to Maria"
    }
  ]
}
```

## WS /live

`/live` streams updates in the same language as `/home`.

Initial event types:

- `home_snapshot`: complete `/home` payload.
- `signal_created`: one new Signal.
- `signal_updated`: one existing Signal with the same `id`.
- `call_updated`: current call state changed.
- `person_updated`: one person or device changed.
- `connection_updated`: Agent health changed.

Example:

```json
{
  "type": "signal_updated",
  "data": {
    "id": "sig_warehouse_returned",
    "state": "resolved",
    "title": "Warehouse phone is back online.",
    "body": "It was unavailable for about 8 minutes.",
    "timeLabel": "Just now"
  }
}
```

## Rules

- Every Signal must include `why`.
- Technical evidence is allowed, but it is one tap deeper in the app.
- The app should never need to know about raw AMI events.
- Signals evolve by stable `id`; do not create a new Signal for every raw
  state change.
- The Agent may observe Asterisk, backups, storage, or security events, but it
  must publish PBXPulse concepts.

