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
        user-select: none;  
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
    }

    .login-box input[type="text"]::placeholder,
    .login-box input[type="password"]::placeholder {
        color: #aaa;
    }

    .login-box a {
        color: #00aaff;
        text-decoration: none;
        font-size: 15px;
        display: block;
        margin: 10px 0;
    }
    
    .a-links {
    	display: flex;
    	justify-content: space-between;
    	margin: 10px, 0;
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
  	  position: absolute;
   	  bottom: 20px;
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

/* 깜빡임 애니메이션 */
@keyframes blink {
    0%, 50%, 100% { opacity: 1; }
    25%, 75% { opacity: 0.3; }
} 

.white {
	background-color: white;
}
</style>

</head>
<body>
	
    <div class="container">
    
        <div class="login-box">
            <h2>로그인</h2>
            <input type="text" placeholder="아이디">
            <input type="password" placeholder="비밀번호">
            <div class="a-links">
	            <a id="test" href="" >비밀번호 찾기</a>
	            <a id="test" href="">아이디 찾기</a>
	            <a href="">회원가입</a>
            </div>
            <button>로그인</button>
        </div>
        
        <div class="bottom-text">Press Space to Start</div>
        
    </div>
    
    <div id="passwordModal">
    	12123
    </div>
  
  	<script type="text/javascript">
  		
		
  	
  	</script>
  
</body>
</html>