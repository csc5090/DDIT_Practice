package com.our_middle_project.frontcontroller;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.util.Properties;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class FrontController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final Properties properties = new Properties();
    // 프로퍼티스는 map의 해쉬테이블 클래스를 상속받은 클래스
    // 아래에 나오는 load(InputStream is) 메서드를 통해 .properties 파일의 내용을 읽어서
    // 내부의 Map 구조에 Key-Value 쌍으로 저장하는 기능에 특화되어 있는 java.util패키지 소속 클래스임.
    
    @Override
    public void init() throws ServletException {
        // webapp/WEB-INF/config/url.properties 파일 경로를 찾습니다.
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/config/url.properties")) {
            //getServletContext() : "이 웹 애플리케이션 전체의 설정 정보를 담당하는 객체를 줘."
        	//.getResourceAsStream(...) : 
        	// "그 객체에서, 지정된 경로(/WEB-INF/config/url.properties)에 있는 파일을 읽을 수 있는 통로(InputStream)를 열어줘."
        	// 즉, is는 url프로퍼티스와 이 웹 어플리케이션(웹페이지) 전체의 설정 정보가 담겨있는 객체와 연결될 수 있는 길 그 자체란 뜻.
        	
        	properties.load(is);
            //load() 메서드는 Properties 클래스에 특화된 메서드.
        	//매개변수 is (InputStream)가 가리키는 데이터의 흐름(길)을 따라서 정보를 읽어 들임.
            //다음과 같은 일이 벌어짐(내부에서)
        	
        	//1.데이터 읽기: InputStream(is). 즉 "is"를 통해 파일(url.properties)의 내용을 한 줄씩, 문자열 형태로 읽어옴.
        	//2.구문 분석: 읽은 문자열에서 = 또는 : 기호를 기준으로 Key와 Value를 구분함.
        	//(예: /login.do 가 키, com.our_middle_project.controller.LoginController 가 값)
        	//3.Map 저장: 구분된 Key와 Value를 properties 객체의 내부 Map 구조에 저장.
        	
        } catch (IOException e) {
            throw new ServletException("설정 파일을 로드 실패.", e);
        }
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {
    	
    	//아래 코드는...
    	//String requestURI = request.getRequestURI(); : 클라이언트가 요청한 전체 경로를 그대로 가져온다.
    	//http://어쩌구...~/Our_Middle_Project/index.do를 요청했다면, requestURI에는 Our_Middle_Project/index.do가 담김.
    	
    	//String contextPath = request.getContextPath(); : 웹 애플리케이션이 웹 서버(컨테이너. 톰캣) 내에서 배포된 루트 경로를 가져온다.
    	// /Our_Middle_Project가 담긴다.
    	
    	//String command = requestURI.substring(contextPath.length());
    	//requestURI 문자열에서 contextPath의 길이만큼 문자열의 앞부분(Our_Middle_Project)을 잘라내 담는다.
    	// /index.do가 담긴다.

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = requestURI.substring(contextPath.length());
        
        //아래 코드는...
        // 두 클래스를 참조해 일종의 일꾼과 그릇을 만듬.
        //ActionForward의 클래스 속에 있는 path,isRedirect를 가져온다.
        ActionForward direct = null; //그릇
        Action action = null; //일꾼

        String className = properties.getProperty(command);
        //getProperty : 키를 이용해 값(Value)를 반환함.
        //즉 className은 command 에 담긴 키 값에 대응하는 벨류를 가지고 있음.
        
        if (className == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "요청한 명령어를 찾을 수 없습니다.");
            return;
        }

        try {
        	// className 변수에 담긴 문자열(패키지 포함 클래스명)을 바탕으로,
            // 해당 클래스의 Class 객체를 메모리에 로드.
        	// Class 객체: 클래스 그 자체의 정의를 나타내는 메타데이터(설계 정보) 객체. 우리가 아는 그 객체(인스턴스)와 다른 개념..
        	// class 객체는 일종의 설계도. 클래스를 쫙 펼친 상태일 뿐.
        	// 우리가 아는 인스턴스는 그 설계도를 찍어낸 실제 생산품. 붕어빵 같은 것.
        	// 와일드카드<?> :  clazz라는 변수에 담길 Class정보가 어떤 타입(클래스)일지 알 수 없기 때문에 이렇게 해둠.
            Class<?> clazz = Class.forName(className);
            
            // 위 코드로드된 클래스 객체(clazz)로부터 생성자(Constructor)를 얻어옴.
            // getConstructor()는 매개변수가 없는 기본 생성자를 찾음.
            // 우리가 자주 쓰던 new는 소스코드에 특정 클래스 이름이 명확하게 있을 때 사용 가능.
            // 하지만 프론트 컨트롤러는 어떤 클래스를 호출할 지 먼저 알 수 없음. 이 문제를 해결하는게 바로 이 리플랙션 코드
            // 이 코드는 즉 얻어올 클래스의 객체를 만들어낼 수 있는 만능 키를 복사하는 과정
            // 이 역시 인스턴스를 생성한 게 아닌, Constructor 클래스 타입의 Class 객체 constructor를 생성한 것.
            Constructor<?> constructor = clazz.getConstructor();
            
            //실제 우리가 아는 인스턴스는 여기서 생성된다.
            //위에서 얻어온 생성도구(클래스의 정보가 담겨 있음)를 이용하여 인스턴스 생성.
            //(Action)으로 형변환 한 이유는, 컴파일러가 어떤 타입의 객체가 반환되는지 알 수 없음.
            // 즉 리플렉션으로 생성된 이 객체는 Action 인터페이스를 구현했으니, Action 타입으로 사용해도 안전하다 라는 걸 컴파일러에게 알리기 위함.
            action = (Action) constructor.newInstance();

            // 아래 코드는...
            // request 인스턴스 : 클라이언트가 보낸 데이터(파라미터, 헤더 등) 및 뷰(View)에 전달할 임시 데이터
            // response 인스턴스 : 클라이언트에게 보낼 응답 정보 (상태 코드, 헤더 등)
            // action: 위에서 만들어 둔 일꾼. 현재는 놀고 있는 상태였으나, 이 코드로 일을 배정해줌.
            // 즉 "일을 시작해!"라고 했을 뿐. 어떤 일을 하는지는 저 아래 코드에서 자세히 설명.
            direct = action.execute(request, response);

            
            //여기서 자세한 일에 대해 알려주게 됨.
            if (direct != null) { //유효성 검사. action.execute() 실행 결과로 direct 객체가 정상적으로 반환되었는지 확인.
                if (direct.isRedirect()) { //direct 객체에 저장된 Redirect가 true인가??
                	//isRedirect가 true라는 것은 action 객체가 "데이터 변경이 발생했으니,
                	//브라우저에게 새로운 URL로 다시 요청하도록 명령해야 한다"고 지시한 것
                	
                	// 아래 코드는... 뒤부터 계산하고 들어가는게 당연히 편하다.
                	// request.getContextPath() : 리퀘스트 객체에 .ContextPath(애플리케이션의 기본 경로(예: /com.our_middle_project)를 붙여준다)
                	// forward.getPath() : action이 지정해준 다음으로 가야할 곳(논리적 경로. 예: /main.do)를 direct 객체에 붙여준다.
                    // 주요 사용처: 데이터베이스 변경(POST) 후 사용자가 F5를 눌러 중복 제출하는 것을 방지할 때 사용
                	response.sendRedirect(request.getContextPath() + direct.getPath());
                	
                } else { //request 객체를 사용하여 서버 내부에서 뷰 페이지(direct.getPath())로 제어권을 넘긴다.

                	// request.getRequestDispatcher(경로): 지정된 경로의 리소스(주로 JSP)로 이동할 준비
                	// .forward(request, response): 서버 내부에서 제어를 넘김. 우리가 만든 게 아닌, 자카르타 내부에 있는 메서드임
                    // 쉽게 말하면 경로를 알려주고, 일로 가라고 명령하는 것.
                	request.getRequestDispatcher(direct.getPath()).forward(request, response);
                	
                	/* Redirect	: "가던 길 취소! 저 주소로 새로 가!" (클라이언트 주소창 변경, 데이터 소멸)
                	 * Forward : "서버 내부에서 바통 터치!" (클라이언트 주소창 변경 없음, 데이터 유지)
                	 */
                	
                }
            }
        } catch (Exception e) {
        	e.printStackTrace();
            throw new ServletException("액션 실행 중 오류 발생", e);
        }
    }
}