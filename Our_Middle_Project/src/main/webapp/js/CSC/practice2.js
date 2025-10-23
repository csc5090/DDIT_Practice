const todoForm = document.getElementById('todo-form');
const todoInput = document.getElementById('todo-input');
const todoList = document.getElementById('todo-list');

todoForm.addEventListener('submit', (e) =>{
	e.preventDefault();
	
	const newTodoText = todoInput.value;
	if (newTodoText.trim() === '') return;
	
	addTodoItem(newTodoText);
	todoInput.value = '';
	todoInput.focus();
	
});

function addTodoItem(text) {
	const li = document.createElement('li');
	li.className = 'todo-item';
	
	li.innerHTML =
		`<span>${text}</span>
		<button class="delete-btn">삭제</button>`;
		
		todoList.appendChild(li);
}

todoList.addEventListener('click', (e)=>{
	
	if (e.target.classList.contains('delete-btn')){
		const li = e.target.parentElement;
		todoList.removeChild(li);
	}
	
	if(e.target.tagName === 'SPAN'){
		const li = e.target.parentElement;
		li.classList.toggle('completed');
	}
	
});