FROM python:3.11-slim
WORKDIR /app
COPY ./app/main.py /app/main.py
RUN pip install flask
EXPOSE 80
CMD ["python", "main.py"]
