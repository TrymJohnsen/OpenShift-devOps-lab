FROM python:3.12-slim

WORKDIR /app

COPY main.py .

# Run as non-root (important for OpenShift SCC compatibility)
RUN adduser --disabled-password --gecos "" appuser
USER appuser

EXPOSE 8080

CMD ["python", "main.py"]
