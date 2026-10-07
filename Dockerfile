FROM python:3.12-slim

WORKDIR /app

# bridge.py is stdlib-only (no pip dependencies needed)
COPY bridge.py /app/bridge.py

ENV BRIDGE_QUEUE=/data/queue \
    PYTHONUNBUFFERED=1

EXPOSE 8765

# /data holds queue/ and keys.json (KEYS_FILE defaults to dirname(QUEUE)/keys.json)
VOLUME ["/data"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python3 -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8765/health', timeout=4)"

CMD ["python3", "/app/bridge.py"]
