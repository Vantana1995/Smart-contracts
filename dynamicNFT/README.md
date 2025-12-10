# DynamicNFT

A simple on-chain **dynamic NFT** implementation in Solidity. This NFT displays an SVG image that reacts to hover events, creating a subtle animation effect entirely on-chain.

## Features

- Fully **on-chain SVG** NFT.
- Dynamic behavior on **hover**.
- Simple and lightweight ERC-721 implementation.
- Comes with a **Forge-based test suite**.

## SVG Example

This is the base64-encoded SVG used in the NFT:

```
data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAg
MzAwIj4NCiAgICA8c3R5bGU+DQogICAgICAgIC5jaXJjbGUgew0KICAgICAgICAgICAgdHJhbnNp
dGlvbjogYWxsIDFzIGVhc2UtaW4tb3V0Ow0KICAgICAgICAgICAgc3Ryb2tlLWRhc2hhcnJheTog
NzMuMjYgNzMuMjY7DQogICAgICAgICAgICBzdHJva2UtZGFzaG9mZnNldDogMzE0Ow0KICAgICAg
ICB9DQogICAgICAgIA0KICAgICAgICAuY2lyY2xlOmhvdmVyIHsNCiAgICAgICAgICAgIHN0cm9r
ZS1kYXNob2Zmc2V0OiAwOw0KICAgICAgICB9DQogICAgPC9zdHlsZT4NCiAgICA8Y2lyY2xlIHI9
IjEwMCIgZmlsbD0iI2NmMTIyMSIgY3g9IjUwJSIgY3k9IjUwJSIvPiAgDQogICAgPGNpcmNsZSBj
bGFzcz0iY2lyY2xlIiByPSI3MCIgZmlsbD0iI2NmMTIyMSIgY3g9IjUwJSIgY3k9IjUwJSIgc3Ry
b2tlPSJnb2xkIiBzdHJva2Utd2lkdGg9IjMwIi8+DQogICAgPGNpcmNsZSByPSIyMCIgY3g9IjUw
JSIgY3k9IjUwJSIgZmlsbD0iZ29sZCIgLz4gIA0KPC9zdmc+
```
