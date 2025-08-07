FROM python:3.9-slim

WORKDIR /app

# Copy requirements first (for better caching)
COPY requirements.txt /app/
RUN pip install -r requirements.txt

# Copy application code and dashboard
COPY main.py /app/
COPY dashboard/ /app/dashboard/

# Expose Flask port
EXPOSE 5000

# Run with gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "main:app"]
