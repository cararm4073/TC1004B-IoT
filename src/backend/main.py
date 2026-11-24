from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

#create a pydantic model-data
class Todo(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    completed: bool = False

#create an array, delete it and connect with msql
todos = []

#endpoints
@app.get("/")
async def read_root():
    return {"message":"Welcome to the xhome API, there is nothing to see here."}

@app.post("/todos/")
async def crate_todo(todo: Todo):
    todos.append(todo)
    return todo

@app.get("/todos/")
async def get_todos():
    return todos

@app.get("/todos/{todo_id}")
async def get_todo(todo_id: int ):
    for todo in todos:
        if todo.id == todo_id:
            return todo
    return {"error":"Element not found"}

@app.put("/todos/{todo_id}")
def update_todo(todo_id: int, updated_todo: Todo):
    for index, todo in enumerate(todos):
        if todo.id == todo_id:
            todos[index] = updated_todo
            return updated_todo
        return {"error":"Element not found, can't update"}

@app.delete("/todos/{todo_id}")
def delete_todo(todo_id: int):
    for index, todo in enumerate(todos):
        if todo.id == todo_id:
            todos.pop(index)
            return {"message":"Element deleted"}
    return{"error":"Element not found, can't delete"}
