FROM python:3.12-slim as builder

#env variables for python which will make sure that the output is not buffered and that bytecode is not written to disk helps to reduce the size of the image and improve performance
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-dev

COPY . .

FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 

RUN groupadd -r app && \
    useradd -r -g app app

WORKDIR /app

COPY --chown=app:app --from=builder /app /app

COPY --chown=app:app --from=builder /bin/uv /bin/uvx /bin/

USER app

EXPOSE 8000

CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
