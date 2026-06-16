from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello!"}

@app.get("/{name}")
def say_hello(name: str, age: int | None = None):
    if age is not None:
        return {"message": f"Hello, {name}! You are {age} years old."}
    return {"message": f"Hello, {name}!"}

