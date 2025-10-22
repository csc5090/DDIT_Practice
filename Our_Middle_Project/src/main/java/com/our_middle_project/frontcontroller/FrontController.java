package com.our_middle_project.frontcontroller;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/* http://localhost:8095/Our_Middle_Project/adminMain.do
 * 우리 주소가 이런식인 이유.
 * 
 * http://localhost:8095/Our_Middle_Project
 * 부분은 서버의 위치와 서버에 설치된 프로그램의 이름을 기준으로 결정된다.
 * 톰캣 서버 안에 설치된 여러 웹 프로젝트 중, 우리가 만든 바로 "그 프로젝트"의 이름.
 * 
 * localhost : 서버가 실행 중인 컴퓨터의 주소. 서버의 물리적 위치.
 * :8095 : 컴퓨터 안에서 톰캣 서버를 찾아가는 번호(포트). 톰캣 서버 자체의 설정.
 * /Our_Middle_Project : 톰캣 서버 안에서 특정 프로젝트를 찾아가는 이름. 이클립스/STS의 배포 설정.
 */

//2025.10.20 프론트 컨트롤러를 싱글톤 패턴으로 업데이트.
//기존의 요청마다 새로운 Action 인스턴스를 생성하는 부분(new Action())은 
//서버 부하를 유발할 수 있다는 가능성이 있음.
//또한 프론트 컨트롤러가 지나치게 많은 역할을 수행하고 있다는 문제점이 있어보임.

// 변경 전: 요청이 올 때마다 new Action() (리플렉션 이용)

// 변경 후: 서버 시작 시 new Action()을 딱 한 번 해두고 재사용

// 간단 비유 : 전에는 손님이 올 때마다 매번 커피 머신을 새로 조립해서 커피를 내렸음.
// 지금은 미리 최고급 커피 머신을 딱 켜놓고 손님이 오면 바로 커피만 내리는 방식으로 바꿈.
// 응답 속도가 훨씬 빨라짐.

public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final Properties properties = new Properties();
	// 프로퍼티스는 map의 해쉬테이블 클래스를 상속받은 클래스
	// 아래에 나오는 load(InputStream is) 메서드를 통해 .properties 파일의 내용을 읽어서
	// 내부의 Map 구조에 Key-Value 쌍으로 저장하는 기능에 특화되어 있는 java.util패키지 소속 클래스임.

	// 아래 코드가 SPA를 구현하기 위한.
	// URL과 실제 Action 싱글톤 인스턴스를 저장할 맵 추가.
	private Map<String, Action> handlerMapping = new HashMap<>();

	@Override
	public void init() throws ServletException {
		// webapp/WEB-INF/config/url.properties 파일 경로를 찾습니다.
		try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/config/url.properties")) {
			
			if (is == null) { // 파일 존재 유무 체크
				throw new ServletException("설정 파일을 찾을 수 없습니다: /WEB-INF/config/url.properties");
			}
			
			// getServletContext() : "이 웹 애플리케이션 전체의 설정 정보를 담당하는 객체를 줘."
			// .getResourceAsStream(...) :
			// "그 객체에서, 지정된 경로(/WEB-INF/config/url.properties)에 있는 파일을 읽을 수 있는
			// 통로(InputStream)를 열어줘."
			// 즉, is는 url프로퍼티스와 이 웹 어플리케이션(웹페이지) 전체의 설정 정보가 담겨있는 객체와 연결될 수 있는 길 그 자체란 뜻.

			properties.load(is);

			// load() 메서드는 Properties 클래스에 특화된 메서드.
			// 매개변수 is (InputStream)가 가리키는 데이터의 흐름(길)을 따라서 정보를 읽어 들임.
			// 다음과 같은 일이 벌어짐(내부에서)

			// 1.데이터 읽기: InputStream(is). 즉 "is"를 통해 파일(url.properties)의 내용을 한 줄씩, 문자열 형태로
			// 읽어옴.
			// 2.구문 분석: 읽은 문자열에서 = 또는 : 기호를 기준으로 Key와 Value를 구분함.
			// (예: /login.do 가 키, com.our_middle_project.controller.LoginController 가 값)
			// 3.Map 저장: 구분된 Key와 Value를 properties 객체의 내부 Map 구조에 저장.

		} catch (IOException e) {
			throw new ServletException("설정 파일을 로드 실패.", e);
		}
		
		// 싱글톤 인스턴스 생성 및 임시 맵에 저장
		// 불변으로 만들기 전 임시 Map 사용
		Map<String, Action> tmpMap = new HashMap<>();

		// 아래 코드가 변경점.
		// 싱글톤 인스턴스 생성 및 맵 저장 로직 추가

		for (Object commandKey : properties.keySet()) {
			String command = (String) commandKey;
			String className = properties.getProperty(command);

			if (className == null || className.trim().isEmpty())
				continue;

			try {
				// A. 리플렉션으로 클래스 로드 및 생성자 획득 (서버 시작 시 1회)
				// className 변수에 담긴 문자열(패키지 포함 클래스명)을 바탕으로,
				// 해당 클래스의 Class 객체를 메모리에 로드.
				// Class 객체: 클래스 그 자체의 정의를 나타내는 메타데이터(설계 정보) 객체. 우리가 아는 그 객체(인스턴스)와 다른 개념..
				// class 객체는 일종의 설계도. 클래스를 쫙 펼친 상태일 뿐.
				// 우리가 아는 인스턴스는 그 설계도를 찍어낸 실제 생산품. 붕어빵 같은 것.
				// 와일드카드<?> : clazz라는 변수에 담길 Class정보가 어떤 타입(클래스)일지 알 수 없기 때문에 이렇게 해둠.

				// className에 "java.lang.String"이 올지, "java.util.Date"가 올지,
				// 아니면 사용자 정의 클래스가 올지 알 수 없기 때문에, 모든 종류의 클래스 타입을 포함할 수 있는
				// 와일드카드(?)를 사용하여 "알 수 없는 임의의 타입에 대한 Class 객체"임을 명시
				Class<?> clazz = Class.forName(className);
				
				if (!Action.class.isAssignableFrom(clazz)) { 
				    throw new ClassCastException("클래스가 Action 인터페이스를 구현하지 않았습니다.");
				}
				
				// 위 코드로드된 클래스 객체(clazz)로부터 생성자(Constructor)를 얻어옴.
				// getConstructor()는 매개변수가 없는 기본 생성자를 찾음.
				// 우리가 자주 쓰던 new는 소스코드에 특정 클래스 이름이 명확하게 있을 때 사용 가능.
				// 하지만 프론트 컨트롤러는 어떤 클래스를 호출할 지 먼저 알 수 없음. 이 문제를 해결하는게 바로 이 리플랙션 코드
				// 이 코드는 즉 얻어올 클래스의 객체를 만들어낼 수 있는 만능 키를 복사하는 과정
				// 이 역시 인스턴스를 생성한 게 아닌, Constructor 클래스 타입의 Class 객체 constructor를 생성한 것.
				Constructor<?> constructor = clazz.getConstructor();
				
				// 실제 우리가 아는 인스턴스는 여기서 생성된다.
				// 위에서 얻어온 생성도구(클래스의 정보가 담겨 있음)를 이용하여 인스턴스 생성.
				// (Action)으로 형변환 한 이유는, 컴파일러가 어떤 타입의 객체가 반환되는지 알 수 없음.
				// 즉 리플렉션으로 생성된 이 객체는 Action 인터페이스를 구현했으니
				// Action 타입으로 사용해도 안전하다 라는 걸 컴파일러에게 알리기 위함.
				Action actionInstance = (Action) constructor.newInstance();
				
				// command(키)와 Action 인스턴스(값)를 handlerMapping에 저장
				tmpMap.put(command, actionInstance);

			} catch (ClassNotFoundException e) {
				throw new ServletException("Action 클래스 파일을 찾을 수 없음: " + className, e);
			} catch (NoSuchMethodException e) {
				throw new ServletException("Action 클래스에 기본 생성자가 없음: " + className, e);
			} catch (InvocationTargetException e) { // 생성자 실행 중 발생한 내부 예외
				throw new ServletException("Action 생성자 실행 중 예외 발생: " + className, e.getTargetException());
			} catch (InstantiationException | IllegalAccessException e) {
				throw new ServletException("Action 인스턴스 생성 및 접근 실패: " + className, e);
			} catch (ClassCastException e) {
				throw new ServletException("Action 인터페이스 구현 오류: " + className, e);
			}
		}
		// 최종 Map을 불변 Map으로 교체 (스레드 안전성 및 방어적 프로그래밍 완성)
		handlerMapping = Collections.unmodifiableMap(tmpMap);
		
		// 메모리 최적화를 위해 더 이상 사용하지 않는 설정 정보 해제
		properties.clear();
	}

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 아래 코드는...
		// String requestURI = request.getRequestURI(); : 클라이언트가 요청한 전체 경로를 그대로 가져온다.
		// http://어쩌구...~/Our_Middle_Project/index.do를 요청했다면, requestURI에는
		// Our_Middle_Project/index.do가 담김.

		// String contextPath = request.getContextPath(); : 웹 애플리케이션이 웹 서버(컨테이너. 톰캣) 내에서
		// 배포된 루트 경로를 가져온다.
		// /Our_Middle_Project가 담긴다.

		// String command = requestURI.substring(contextPath.length());
		// requestURI 문자열에서 contextPath의 길이만큼 문자열의 앞부분(Our_Middle_Project)을 잘라내 담는다.
		// /index.do가 담긴다.

		String requestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		String command = requestURI.substring(contextPath.length());
		
		// 아래 코드는...
		// 두 클래스를 참조해 일종의 일꾼과 그릇을 만듬.
		// ActionForward의 클래스 속에 있는 path,isRedirect를 가져온다.
		ActionForward direct = null; // 그릇
		Action action = handlerMapping.get(command); // 위에 객체가 가득 담겨잇는 map에서 key(/indox.do)에 맞는
		// 벨류 값을 찾아 action 변수에 넣음.

		if (action == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "요청한 명령어를 찾을 수 없음.");
			return;
		}

		try {

			// 아래 코드는...
			// request 인스턴스 : 클라이언트가 보낸 데이터(파라미터, 헤더 등) 및 뷰(View)에 전달할 임시 데이터
			// response 인스턴스 : 클라이언트에게 보낼 응답 정보 (상태 코드, 헤더 등)
			// action: 위에서 만들어 둔 일꾼. 현재는 놀고 있는 상태였으나, 이 코드로 일을 배정해줌.
			// 즉 "일을 시작해!"라고 했을 뿐. 어떤 일을 하는지는 저 아래 코드에서 자세히 설명.
			// 이미 싱글톤 Action 인스턴스를 가져왔으므로 바로 execute() 실행
			direct = action.execute(request, response);

			// 여기서 자세한 일에 대해 알려주게 됨.
			if (direct != null) { // 유효성 검사. action.execute() 실행 결과로 direct 객체가 정상적으로 반환되었는지 확인.
				if (direct.isRedirect()) { // direct 객체에 저장된 Redirect가 true인가??
					// isRedirect가 true라는 것은 action 객체가 "데이터 변경이 발생했으니,
					// 브라우저에게 새로운 URL로 다시 요청하도록 명령해야 한다"고 지시한 것

					// 아래 코드는... 뒤부터 계산하고 들어가는게 당연히 편하다.
					// request.getContextPath() : 리퀘스트 객체에 .ContextPath(애플리케이션의 기본 경로(예:
					// /com.our_middle_project)를 붙여준다)
					// forward.getPath() : action이 지정해준 다음으로 가야할 곳(논리적 경로. 예: /main.do)를 direct 객체에
					// 붙여준다.
					// 주요 사용처: 데이터베이스 변경(POST) 후 사용자가 F5를 눌러 중복 제출하는 것을 방지할 때 사용
					response.sendRedirect(request.getContextPath() + direct.getPath());

				} else { // request 객체를 사용하여 서버 내부에서 뷰 페이지(direct.getPath())로 제어권을 넘긴다.

					// request.getRequestDispatcher(경로): 지정된 경로의 리소스(주로 JSP)로 이동할 준비
					// .forward(request, response): 서버 내부에서 제어를 넘김. 우리가 만든 게 아닌, 자카르타 내부에 있는 메서드임
					// 쉽게 말하면 경로를 알려주고, 일로 가라고 명령하는 것.
					request.getRequestDispatcher(direct.getPath()).forward(request, response);
					
					/*
					 * Redirect : "가던 길 취소! 저 주소로 새로 가!" (클라이언트 주소창 변경, 데이터 소멸) Forward :
					 * "서버 내부에서 바통 터치!" (클라이언트 주소창 변경 없음, 데이터 유지) 이걸 결정해주는 코드라는 뜻.
					 */
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("액션 실행 중 오류 발생", e);
		}
	}
}