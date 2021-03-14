# workOut_Tracker

A new Flutter project.
기능: 운동 종목별 기록 tracking. / 내가 하는 운동 종목들만 관리 가능. (추가 시장조사 필요)


# To do    
- provider 적용(stateful유지할곳(local state)은 유지.)     
- stateful 불필요한곳 지우기   
- 디자인 변경 및 theme 추가(dev tool로 layout확인하며 개발.)    
- 애니메이션 추가  (event Tile(축소/확대),) (성능 고려. 너무 많이말고 필요한 곳만.)   
- 폰트 추가      
- 달력에 종목별 표기 버튼 및 달력rendering.   
- 로딩페이지 구현.(로고 애니메이션 / 스크린 이동버튼 )    
- Android/Ios 분리     
- 지원 모드 지정.     
- tab화면 이동시 기존변수들 유지. (provider 적용 후)
- performance 최적화(build함수내 print활용하여별 동작별 위젯의 빌드여부 확인. / const위젯)
- 운동 볼륨 표시
- 설정 페이지: 운동목록 이름순 정렬. 날짜순 정렬. / 
- 이름이 undefined인 운동 추가시 필터 정렬 안되는 버그 fix.
- 각종 device에 test(keyboard 렌더링될 때, Text(kg,횟수 등) 범위가 초과할때(:overflow 추가) 등등 layout확인)
- 달성률 저장 기능
- 메모 기능    
- 카운터 기능, 타이머 기능   
- 아이폰 고려. safeArea.    
---------------------------------
- addEvent textfield form으로
- test,image등 fittedBox로 wrap하여 사용(혹은 overflow지정?)
- switch.adaptive적용
- onUnknownRoute추가
- InkWell 사용할만한 곳?: 오늘의운동관리하러가기?
- 코드간결화 및 정리. split widgets, builder method. 
- eventList에 divider
- 필터에 스위치말고 체크표시. Icon.check_box(outlined)
- 생성자로 passing하는 변수명 같게 유지하지말고 조금씩 다르게.
- id를 now()말고 다르게 지정. (now는 디버그시에만 간편사용.)
- 무게에 toStringAsFixed 사용.
- 운동 추가, 삭제 등을 생성자로 받은 List에 직접하지말고 상위레벨에서 함수(add,delete)전달받아서 실행.   
- listview children -> builder(운동종목숫자 모를시.) / listview.separated   
- map의 key가 없을때 추가시 -> putIfAbsent / value update 시 -> update     
- map의 forEach가능. (toEntries 필요x)     
- Badge같은 custom widget사용 가능한곳있는지 확인.    
- 디자인 등은 많은 다른 코드 및 예제앱 코드 참조. (card를 container로 감싸는지, container를 card로 감싸는지, padding,margin 처리 등)    
- event tile의 set column을 listview로하고 listview의 container의 height을 min(갯수*20+10, 100)으로 설정. 일정크기넘어가면 scroll하게.    
- context, ctx 혼용되있는곳(Navigator.of(ctx).pop 같이) 다시 전부 확인, 구분해서 사용. 현위젯의 context(builder라면 builder에 전달된 context를 사용)
- Form 개선. TextInputActioin.next /     
- TextEditingController dispose 추가       
- FocusNode 사용가능하면 추가, unFocus()도   
- Form 개선. TextInputActioin.next / validator 수정.(value.isEmpty, can parse double etc)     
- future, then -> async, await으로 수정. error는 try&catch,throw으로 관리.      
- hero 사용가능하면 추가    
- 페이지 pop할때 받을 객체의 타입을 as말고 push<T>로 명시. 
- Function 생성자로 전달시, 받는 클래스 내에서 함수 형태를 규정.      
- input에 trim()추가.      
- pageTransition/ customRoute
- LayoutBuilder    
- dismissable
- 공유 기능
- dismissable    
- 메모리 leak안생기는지 확인.   
