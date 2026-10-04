FROM python:3.12-slim
 
# uv is needed so the override-dependencies in pyproject.toml are respected
COPY --from=ghcr.io/astral-sh/uv:0.11 /uv /uvx /bin/
 
ENV PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never \
    MPLBACKEND=Agg \
    PORT=8000
 
WORKDIR /app
 
# Install dependencies first so this layer is cached when only code changes
COPY pyproject.toml uv.lock* ./
RUN uv sync --no-dev --no-install-project
 
# Copy the rest of the project (api/index.py and everything else)
COPY . .
 
ENV PATH="/app/.venv/bin:$PATH"
 
EXPOSE 8000
 
CMD exec gunicorn --bind 0.0.0.0:${PORT} --workers 2 --timeout 120 index:app
