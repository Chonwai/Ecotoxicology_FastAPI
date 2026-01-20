FROM python:3.9

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    libglib2.0-0 \
    libgl1-mesa-dri \
    libglx-mesa0 \
    libgl1-mesa-dev \
    libgles2-mesa-dev \
    libegl1-mesa-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py", "--host", "0.0.0.0", "--port", "8890"]