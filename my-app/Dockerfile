FROM python:3.9-slim

WORKDIR /app

COPY app/ /app/
# OR
COPY app/main.py /app/

# Install dependencies if you have requirements.txt
# COPY requirements.txt /app/
# RUN pip install -r requirements.txt

CMD ["python", "main.py"]
