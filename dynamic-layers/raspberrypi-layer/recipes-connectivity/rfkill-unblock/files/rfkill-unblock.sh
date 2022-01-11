#!/bin/bash
echo "Initial RF device states:"
rfkill list
echo "Unblocking RF devices ... "
rfkill unblock all
echo "Modified RF device states:"
rfkill list