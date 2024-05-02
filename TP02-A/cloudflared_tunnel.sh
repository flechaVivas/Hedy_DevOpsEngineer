#!/bin/bash

curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && 
sudo dpkg -i cloudflared.deb && 
sudo cloudflared service install eyJhIjoiZDU4YmQ3M2M2YmNiMTQ2ZjViMDVlN2UyZGEyZjhhN2EiLCJ0IjoiZGY1YjQxNjEtZGUyNS00N2U2LWIwZDctMDU1N2Q1YjllODc4IiwicyI6Ik1HRmpNemt6TVRBdE9UY3dZaTAwTnpnd0xXSmxNbVF0WkRoak9XUTRaR0pqTTJWaCJ9

