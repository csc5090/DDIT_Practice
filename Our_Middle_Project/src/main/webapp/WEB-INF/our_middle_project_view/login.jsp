<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

<style>
    body {
        margin: 0;
        padding: 0;
        color: white;
    }

    .container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 100vh;
        background-color: black;
        position: relative;
	}
	 
	 .login-box {
        background-color: #1e1e1e;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
        width: 300px;
        text-align: center;
        transform: translateY(80px);
    }

    .login-box h2 {
        margin-bottom: 20px;
        font-weight: normal;
    }

    .login-box input[type="text"],
    .login-box input[type="password"] {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
        border-radius: 6px;
        border: none;
        background-color: #333;
        color: white;
        box-sizing: border-box;
    }

    .login-box input[type="text"]::placeholder,
    .login-box input[type="password"]::placeholder {
        color: #aaa;
    }

    .div-links {
    	display: flex;
    	justify-content: space-between;
    	margin: 10px 0;
    }
    
    .div-links div {
   	 	color: #00aaff;
     	text-decoration: none;
     	font-size: 15px;
     	cursor: pointer;
	}

	.div-links div:hover {
     	color: #fff;
     	text-shadow: 0 0 5px #0ff;
	}

    .login-box button {
        width: 100%;
        padding: 10px;
        margin-top: 10px;
        border: none;
        border-radius: 6px;
        background-color: #00aaff;
        color: white;
        cursor: pointer;
        font-size: 1em;
    }

    .login-box button:hover {
        background-color: #0088cc;
    }
	
	.bottom-text {
	  user-select: none;  
  	  position: absolute;
   	  bottom: 50px;
   	  font-size: 30px;
  	  color: #fff;
  	  text-shadow:
        0 0 5px #fff,
        0 0 10px #fff,
        0 0 20px #fff,
        0 0 40px #0ff,
        0 0 80px #0ff;
      
      animation: blink 2s infinite;
}

@keyframes blink {
    0%, 50%, 100% { opacity: 1; }
    25%, 75% { opacity: 0.3; }
} 

 .modal {
        display: none;
        position: absolute;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.7);
    }

    .modal-content {
  	    position: absolute;   
        top: 50%;
        left: 50%;
    	transform: translate(-50%, -50%); 
    	background-color: #1e1e1e;
    	padding: 30px;
    	border-radius: 10px;
    	width: 300px;
    	text-align: center;
    	box-shadow: 0 0 15px rgba(0, 255, 255, 0.5);
	}

    .modal-content h3 {
        margin-bottom: 15px;
        color: #00ffff;
    }

    .modal-content input {
        width: 100%;
        padding: 8px;
        margin: 8px 0;
        border: none;
        border-radius: 6px;
        background-color: #333;
        color: white;
        box-sizing: border-box;
    }

    .modal-content button {
        width: 100%;
        padding: 10px;
        margin-top: 10px;
        border: none;
        border-radius: 6px;
        background-color: #00aaff;
        color: white;
        cursor: pointer;
    }

    .close-btn {
        margin-top: 15px;
        color: #aaa;
        font-size: 14px;
        cursor: pointer;
    }

    .close-btn:hover {
        color: #fff;
    }
    
</style>

</head>
<body>
	
    <div class="container">
    
        <div class="login-box">
            <h2>로그인</h2>
            <input type="text" placeholder="아이디" >
            <input type="password" placeholder="비밀번호">
            <div class="div-links">
	            <div class="find-id">아이디 찾기</div>
	            <div class="find-pw">비밀번호 찾기</div>
	            <div>회원가입</div>
            </div>
            <button>로그인</button>
        </div>
        
        <div class="bottom-text">Press the spacebar</div>
    </div>
    
 <div id="idModal" class="modal">
        <div class="modal-content">
            <h3>아이디 찾기</h3>
            <input type="text" placeholder="이메일">
            <button>아이디 찾기</button>
            <div class="close-btn" onclick="closeModal('idModal')">닫기</div>
        </div>
 </div>

 <div id="pwModal" class="modal">
        <div class="modal-content">
            <h3>비밀번호 찾기</h3>
            <input type="text" placeholder="아이디">
            <input type="text" placeholder="이메일">
            <button>비밀번호 재설정</button>
            <div class="close-btn" onclick="closeModal('pwModal')">닫기</div>
        </div>
 </div> 
  
  
<script>

	window.onload = () => {
	
		    const idModal = document.getElementById('idModal');
		    const pwModal = document.getElementById('pwModal');
		    const findId = document.querySelector('.find-id');
		    const findPw = document.querySelector('.find-pw');

		    findId.addEventListener('click', () => idModal.style.display = 'block');
		    findPw.addEventListener('click', () => pwModal.style.display = 'block');

		    window.addEventListener('click', (e) => {
		        if (e.target === idModal) idModal.style.display = 'none';
		        if (e.target === pwModal) pwModal.style.display = 'none';
		    });
	}
	
    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }

	
</script>
  
</body>
</html>