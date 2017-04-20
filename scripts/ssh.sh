#!/bin/bash

ssh localhost -p 8022 -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null $@
