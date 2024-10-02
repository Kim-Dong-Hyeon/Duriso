# Duriso(두리소)

<img src="https://github.com/user-attachments/assets/dfe5ae23-0ca6-42d3-b6f7-ae33ec9481ac" alt="app store 6.5.jpg" width=""/>

<img src="https://github.com/user-attachments/assets/bb85b8d1-9db5-4b8d-aeee-fa943e874bce" alt="브로셔" width="">

---

## 📱 프로젝트 소개

- 프로젝트 명 : 두리소 Duriso
- 소개
    - 한줄 소개
        - “두리소”는 재난 상황에서 대피소 정보와 행동 요령을 제공하여 안전하게 대처할 수 있도록 돕는 재난 대피 안내 앱입니다.
    - 주요 기능
        - 네트워크 오프라인 및 온라인에서 대피소, AED 정보 제공
        - 온라인 상태에서 제보 커뮤니티를 통한 위험 상황 전파
        - 상황별 행동 요령 안내
    - 내용
        
        **두리소**는 재난 상황에서 온라인·오프라인 모두 사용 가능한 대피소, AED 정보 제공과 재난 상황 시 행동요령을 안내합니다.
        또한, 실시간 재난 및 안전 정보를 공유할 수 있는 커뮤니티 기능을 통해 빠르고 정확한 대처 방법을 공유할 수 있습니다.
    - 📱 **서비스 링크**: [ App Store - 두리소 Duriso](https://apps.apple.com/kr/app/%EB%91%90%EB%A6%AC%EC%86%8C-duriso/id6670236039)
        

## 🧑🏻‍💻 팀원 소개 (Team)

| <img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1567062204/noticon/ttan57gjenhvcrfq10yo.png" width="20px"> [Kim-Dong-Hyeon](https://github.com/Kim-Dong-Hyeon) | <img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1567062204/noticon/ttan57gjenhvcrfq10yo.png" width="20px"> [shinsangkyu6660](https://github.com/shinsangkyu6660) | <img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1567062204/noticon/ttan57gjenhvcrfq10yo.png" width="20px"> [jjoohee95](https://github.com/jjoohee95) | <img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1567062204/noticon/ttan57gjenhvcrfq10yo.png" width="20px"> [HwaN310](https://github.com/HwaN310) |
| --- | --- | --- | --- |
|  |  |  |  | 
| 팀장 | 부팀장 | 팀원 | 팀원 |
| - 프로젝트 초기 세팅 <br> - **오프라인 맵** <br> - 파이어베이스 구성 <br> - 앱 배포 <br> - API활용 | - **커뮤니티** <br> - **행동요령** <br> - 파이어베이스 활용 <br> - API활용 | - 로고 및 아이콘 제작 <br> - **온라인 맵** <br> - 파이어베이스 활용 <br> - API활용 | - **로그인/회원가입** <br> - **마이페이지** <br> - 파이어베이스 활용 | 
<br/>

## ⚒️ 기술 스택 (Tech)

| **범위** | **기술 이름** |
| --- | --- |
| 의존성 관리 도구 | **`SPM`** |
| 형상 관리 도구 | **`GitHub`, `Git`** |
| 아키텍처 | **`MVVM`** |
| 디자인 패턴 | **`Singleton`, `Delegate`, `Observer`** |
| 인터페이스 | **`UIKit`** |
| 비동기 처리 | **`RxSwift`** |
| 레이아웃 구성 | **`SnapKit`, `Then`**, **`IQKeyboardManagerSwift`** |
| 내부 저장소 | **`UserDefaults`, `CoreData`, `Firebase Realtime Database`** |
| 외부 저장소 | **`Firebase Firestore`** |
| 외부 인증 | **`Firebase Auth`, `Sign in with Apple`, `KakaoOpenSDK`** |
| 지도 | **`KakaoMapsSDK`, `MapLibre Native`** |
| 이미지 처리 | **`Kingfisher`** |
| 네트워킹 | **`Alamofire`, `RESTful API`** |
| 코드 컨벤션 | **`StyleShare - Swift Style Guide`**, **`SwiftAPI`** |
| 커밋 컨벤션 | **`Udacity Git Commit Message Style Guide`** |

## 📱 주요 기능

기능 시연 영상 : https://youtu.be/EXk_NXo28A4

<img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1575058160/noticon/eu6uhubcgqfm6f0ova6t.svg" alt="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1575058160/noticon/eu6uhubcgqfm6f0ova6t.svg" width="40px" />

온라인 맵

- 인터넷 연결을 통해 실시간으로 대피소 위치를 확인하고, 현재 위치를 기반으로 대피소 및 심장 제세동기의 위치와 정보에 대해 정보를 제공 합니다.
- 사용자는 온라인 상태에서 가장 빠르고 정확한 대피소 정보를 얻을 수 있으며, 재난 발생 시 즉시 대응할 수 있습니다.
- 온라인 맵 핵심 기능
    
    <img src="https://github.com/user-attachments/assets/f8704d9c-07e6-40e4-b344-acb19ec64d43" alt="온라인 맵 핵심 기능 User Flow" width="">

<img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1678578202/noticon/ugqrtf9phazahipuorcj.png" alt="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1678578202/noticon/ugqrtf9phazahipuorcj.png" width="40px" />

오프라인 맵

- 인터넷 연결이 불가능한 상황에서도 대피소 및 심장 제세동기 위치를 확인할 수 있는 기능입니다.
- 미리 다운로드 된 데이터를 바탕으로 사용자 위치에 따른 대피소 안내를 제공하며, 갑작스러운 네트워크 장애 시에도 안전하게 대피할 수 있도록 지원합니다.
- 오프라인 맵 핵심 기능
    
    <img src="https://github.com/user-attachments/assets/fcdc94df-a22d-4eda-930c-f41e1ae35e06" alt="오프라인 맵 핵심 기능 User Flow" width="">

👥 커뮤니티

- 사용자들이 재난 상황에 대한 정보를 실시간으로 공유할 수 있는 커뮤니티 기능입니다.
- 지역별로 발생한 재난 소식, 피해 상황, 대처 방법 등을 다른 사용자들과 나누며 빠르게 대처할 수 있습니다.
- 사용자 간의 정보 공유를 통해 더 안전한 환경을 제공합니다.
- 커뮤니티 핵심 기능
    
    <img src="https://github.com/user-attachments/assets/240957b5-9ca4-4376-b5a1-847d738fbe37" alt="커뮤니티 핵심 기능 User Flow" width="">

🏃🏻 행동요령

- 재난 상황 시 신속하고 정확한 대처를 위한 국가에서 제공하는 행동요령 정보를 제공하며, 영상자료를 통해 평상시에도 행동 요령을 익힐 수 있도록 도와줍니다.
- 행동요령 핵심 기능
    
    <img src="https://github.com/user-attachments/assets/a2e3a22b-81c7-4bcc-9be3-9c390b0350d7" alt="행동요령 핵심 기능 User Flow" width="">

##  기술적 의사결정

- 기술적 의사 결정
    - **MVVM**: View와 Model 사이의 의존성을 줄이고, ViewModel을 통한 데이터 바인딩으로 로직을 효율적으로 구현하고 UI와 비즈니스 로직을 분리하여 코드 가독성을 높이고 유지 보수, 추후 테스트의 용이성을 높이기 위함
    - **RxSwift**: 비동기 작업을 단순화하고 코드의 가독성과 유지보수성을 높여 **비동기 처리**를 더욱 효율적으로 구현하기 위해 선택.
    - **Alamofire**: 기존 First Party인 URLSession보다 네트워크 호출을 간편하고, 가독성과 효율적 처리를 위해 선택.
    - **Firebase**: 백엔드 구현 없이 데이터베이스와 인증 서비스를 간편하게 사용 가능하며, **소셜 로그인** 기능도 손쉽게 통합할 수 있음.
        - ERD
            
            <img src="https://github.com/user-attachments/assets/6351d8c6-73ed-4869-981b-9ad779a4447c" alt="ERD" width="">
            
    - **CoreData**: Firebase Realtime Database를 통해 받아온 대용량의 오프라인 데이터들을 기기에 저장하기 위해 사용.
    - **KakaoMapsSDK**: **한국 유저**들에게 친숙한 지도 서비스로, 최신 지도 데이터를 제공하며 사용자 경험을 최적화.
    - **MapLibre Native**: **오프라인 지도** 지원이 가능한 서비스로, 인터넷 연결이 불가능한 상황에서도 지도 기능을 제공.
    - **Then**: **UI 구현** 시 코드를 간결하고 명료하게 작성할 수 있는 라이브러리로, 개발 생산성을 향상.
    - **PDFKit**: First Party 프레임워크로, PDF파일을 조금 더 쉽고 간편하게 보여줄수 있음.

##  트러블 슈팅

- **UICollectionView(Carousel) 적용 이슈**
    
    ## 문제상황
    
    - **이미지 로드 문제** : UICollectionView의 Carousel에서 이미지가 표시되지 않음.
    - **셀 크기 문제** : 셀의 크기가 너무 작아 Carousel 효과가 제대로 나타나지 않으며, 셀이 잘 보이지 않음.
    - **스크롤 문제** : 스크롤이 정상적으로 작동하지 않아 사용자가 Carousel을 움직일 수 없는 상태.
    - **중복 셀 문제** : 셀이 한 화면에 20개씩 중복으로 표시되는 현상이 발생하여 레이아웃이 비정상적으로 보임.
    
    ## 문제 해결
    
    ### 해결방안
    
    1. **썸네일 로드** : 구글링을 통해 적절한 썸네일 추출 방식을 찾고, 이를 동영상 파일에서 추출하여 이미지로 Carousel에 표시.
    2. **썸네일과 동영상 병합** :  셀이 한 화면에 20개씩 중복되는 현상을 막기 위하여 썸네일을 동영상과 함께 Carousel에 넣어 사용자가 더욱 직관적으로 콘텐츠를 탐색할 수 있도록 개선.
    3. **셀 크기 조정 및 스크롤 문제 해결** : 셀의 크기를 적절하게 설정하고, 스크롤 동작을 수정하여 사용자가 Carousel을 원활하게 탐색할 수 있도록 개선.
    
- 카메라, 포토 라이브러리 접근 권한 요청 메시지 이슈
    
    ## 문제상황
    
    - **권한 요청 메시지 내용 오류**: info.plist에 Privacy - Camera Usage Description, Photo Library Usage Description을 작성했음에도 불구하고 권한 요청 메시지가 정상적으로 표시되지 않음.
    
    |![비정상적인 카메라 권한 요청 메시지 화면](https://github.com/user-attachments/assets/f550f583-b7a3-4065-9f0f-b175b6dcf1cb) | ![비정상적인 사진 보관함 권한 요청 메시지 화면](https://github.com/user-attachments/assets/82bbaab5-6a9b-443c-9ee3-c2d2c643a1d1)
    |---|---|
    | 비정상적인 카메라 권한 요청 메시지 화면 | 비정상적인 사진 보관함 권한 요청 메시지 화면 |
    
    ## 문제 해결
    
    ### 해결과정
    
    - **클린 빌드 후에도 동일 현상**: 클린 빌드 및 관련 파일 삭제를 시도했으나, 동일한 권한 요청 문구가 나타남.
    - **코드 상 문제 미발견**: 카메라 및 포토 라이브러리 접근 코드를 확인했으나, 특별한 오류가 보이지 않음.
    - **전문가 의견 확인**: 이 문제를 해결하기 위해 튜터님에게 도움을 요청하여 문제점을 진단.
    - **info.plist 충돌 문제 확인**: info.plist 파일과 Build Settings에서 서로 충돌이 발생하는 문제를 발견, 이를 수정함.
        
        <img src="https://github.com/user-attachments/assets/5d3c2db0-c3f4-4bd2-b1b6-b2f002f60057" alt="info.plist 충돌 문제 이미지" width="">
        
    - **빌드 설정 정리**: 프로젝트 타겟의 빌드 설정에서 불필요한 설정 항목을 삭제하여 오류를 해결하고 권한 요청 메시지가 정상적으로 표시되도록 조치. (프로젝트→ TAGETS→ Build Settings→ 동일한 Privacy - Camera Usage Description삭제)
        
        <img src="https://github.com/user-attachments/assets/eff1d2ee-5dbd-43f9-ad93-2cfdf08694ad" alt="빌드 설정 정리 이미지 1" width="">
        
        <img src="https://github.com/user-attachments/assets/2f8b6939-b682-468c-9504-bbc4c99f2196" alt="빌드 설정 정리 이미지 2" width="">
        
    
    ## 결과 및 프로젝트 반영 / 차선책
    
    ### 문제 해결된 결과
    
    - Info.plist에 작성한 내용대로 정상적으로 권한 요청 메시지 출력됨
    
    |![카메라 권한 요청 화면](https://github.com/user-attachments/assets/5845e887-3d05-41a2-a783-4630ec13529f) | ![사진 보관함 권한 요청 화면](https://github.com/user-attachments/assets/7d732590-220c-42f6-82c3-95efea36db1e) |
    |---|---|
    | 카메라 권한 요청 화면 | 사진 보관함 권한 요청 화면 |
    
- 공공데이터포털 API이슈
    - AED API Issue
        
        ## 문제상황
        
        - AED API의 요청 변수에 위도 경도 값이 존재 하지 않아서 
        반경 데이터를 가져오는데 문제가 발생함
        
        ## 문제 해결
        
        ### **해결방안 논의**
        
        - 1안 : 공공데이터 포털에 요청변수 추가 요청하기
        - 2안 : 앱 최초 실행 시 모든 데이터를 받아서 UserDefaults에 저장해서 위경도 값 필터링 해서 가져오기
        
        ### **논의 과정**
        
        - https://github.com/Kim-Dong-Hyeon/Duriso/issues/56
            
            <img src="https://github.com/user-attachments/assets/74fcf8b2-f71f-43c3-90da-fcc8da300644" alt="AED API Issue 스크린샷" width="">

            
        - github issue로 등록하여 논의 및 스크럼 시간 논의 통해 1안 신청, 2안으로 진행 한 후 api 수정요청이 반영된 후 api호출로 변경 하기로 함
        
        ### 해결과정
        
        - **재난안전 공공데이터 공유 플랫폼 문의(9월 11일)**
            
            <img src="https://github.com/user-attachments/assets/0ebfced7-1634-43fa-a361-cd0f948f81f8" alt="재난안전 공공데이터 공유 플랫폼 문의 스크린샷" width="">

            
        - **API 전체 데이터 UserDefaults에 저장하기**
            - **UserDefaults**에서 AED 데이터를 로드하고, 데이터가 있으면 로드된 데이터를 반환, 데이터가 없을 경우, 네트워크 요청을 통해 전체 범위의 AED 데이터를 가져와 **UserDefaults**에 저장한 후, 데이터를 반환하도록 구현함
                - UserDefaults 사용한 코드
                    
                    ```swift
                    // MARK: - 전체 AED 데이터 요청 및 UserDefaults에 저장
                      func fetchAllAeds() -> Observable<AedResponse> {
                        // UserDefaults에서 데이터 로드
                        if let storedAeds = loadAeds() {
                          return Observable.just(storedAeds)
                        }
                        
                        // 전역 범위로 데이터 요청
                        let boundingBox = (startLat: -90.0, endLat: 90.0, startLot: -180.0, endLot: 180.0)
                    
                        return Observable.create { observer in
                          self.aedNetworkManager.fetchAllAeds(boundingBox: boundingBox)
                            .subscribe(onNext: { response in
                              // UserDefaults에 저장
                              if let data = try? JSONEncoder().encode(response) {
                                UserDefaults.standard.set(data, forKey: "AedData")
                                print("전체 AED 데이터가 UserDefaults에 저장되었습니다.")
                              }
                              observer.onNext(response)
                              observer.onCompleted()
                            }, onError: { error in
                              observer.onError(error)
                            })
                            .disposed(by: self.disposeBag)
                          
                          return Disposables.create()
                        }
                      }
                      
                      // MARK: - UserDefaults에서 AED 데이터 로드
                      func loadAeds() -> AedResponse? {
                        if let data = UserDefaults.standard.data(forKey: "AedData"),
                           let aedResponse = try? JSONDecoder().decode(AedResponse.self, from: data) {
                          return aedResponse
                        }
                        return nil
                      }
                    ```
                    
            - 이 과정에서 **RxSwift**의 **Observable**을 사용해 비동기적으로 데이터를 처리하고, 네트워크 요청 및 에러 처리 또한 **RxSwift**로 관리하고 있습니다.
                - RxSwift로 관리한 이유
                    
                    사용자가 지도 위치를 변동하여 정보를 요청 할 때마다 데이터 요청이 발생하고, 이를 여러 번 처리하거나, 요청 후 UI 업데이트를 수행해야 해서,  RxSwift를 사용해 복잡한 흐름을 하나의 데이터 스트림으로 처리해 코드의 가독성과 유지보수성을 향상시켰습니다
                    
            - UserDefaults로 처리중 데이터 용량 크기 문제 발생..
                - UserDefaults 디버깅 로그
                    
                    ```swift
                    CFPrefsPlistSource<0x600003004a20> (Domain: com.donghyeon.Duriso, User: kCFPreferencesCurrentUser, ByHost: No, Container: (null), Contents Need Refresh: Yes): Attempting to store >= 4194304 bytes of data in CFPreferences/NSUserDefaults on this platform is invalid. This is a bug in Duriso or a library it uses.
                    Description of keys being set:
                    autoLogin: boolean value
                    
                    Description of keys already present:
                    AedData: data value, size: 8080715
                    VersionOfLastRun: string value, approximate encoded size: 1
                    autoLogin: boolean value
                    ```
                    
                - 오프라인 맵의 AED 데이터 사용 위해 작업해둔 FireBase, CoreData 활용하여 구현 하도록 변경 예정
        - 재난안전 공공데이터 플랫폼 문의 반영 됨!!
            - 9월 27일 빠른시일 내에 반영할 수 있도록 하겠다는 답변 받음
                
                <img src="https://github.com/user-attachments/assets/9a0e1108-6876-4e80-a467-ccf656d784a4" alt="답변 스크린샷" width="">

                
            - 반영 된 요청 변수
                
                <img src="https://github.com/user-attachments/assets/3c98a917-cea7-4263-ab0c-2fd7ab328b6e" alt="반영 된 요청 변수 스크린샷" width="">

                
        
        ## 결과 및 프로젝트 반영 / 차선책
        
        ### ver 1.0.0 에는 UserDefaults로 배포
        
        - 데이터 용량에러 로그 발생했지만 데이터 불러오는 것에서는 문제 없는 것 확인 완료
        - 추후 배포시 변경된 요청변수로 api 요청 위해 수정중
        
    - 연합뉴스 API Issue
        
        ## 문제상황
        
        - 연합뉴스의 재난 상황에 대한 뉴스 타이틀 제공 API 활용하려고 했으나 파일 최신화가 이루어 지지 않는 것 확인
        - API 최신화 요청하여 최신화 해서 갱신되도록 하였지만, 재난 안전 뉴스 타이틀만 가져올 수 없음
        
        ## 문제 해결
        
        ### **해결 방안 논의**
        
        - 1안: 연합 뉴스에 데이터 갱신 요청 하기
        - 2안: 긴급재난 문자로 변경하기
        
        ### 해결과정
        
        - 연합뉴스 API 데이터 담당자와 통화
            - 유료배포로 변경 된 것으로 알고 있다, 다시 확인 후 연락 주겠다
            - 공공 데이터 포탈에 데이터 최신화 갱신 됨
            - 데이터 최신화는 되지만 재난상황에 관련된 데이터만  받아 올 수 있는 방법이 없음
            
        - 긴급 재난 문자로 변경하기로 함
        
        ## 결과 및 프로젝트 반영 / 차선책
        
        ### 긴급 재난 문자로 변경하여 배포
        
        - 최신 5개 문자로 변경하여 배포함
        
        ### 향후 계획
        
        - 지역 반경 설정하여 사용자의 지역 내 긴급 재난 문자만 최신화 되도록 변경
        
    - **방독면 정보 미제공 Issue**
        
        ## 문제상황
        
        - 방독면 정보를 AED, 대피소와 같이 표시해주고자 함.
        - 공공데이터포털과 재난안전데이터공유플랫폼에 “대구교통공사”를 제외한 정보 데이터 없음.
        - 검색 결과 화면
            
            <img src="https://github.com/user-attachments/assets/9d4b3acb-c87e-47c4-83ce-851642d83d0c" alt="공공데이터포털 - 방독면 검색 결과 스크린샷" width="">
            
            <img src="https://github.com/user-attachments/assets/4b95fe4d-bc67-4157-8d13-961e033aa50f" alt="재난안전데이터공유플랫폼 - 방독면 검색 결과 스크린샷" width="">
            
        
        ## 문제 해결
        
        ### 해결과정
        
        - **공공데이터포털에 행정안전부 대상으로 공공데이터 제공신청 (8월 27일)**
            - 제공신청 화면
                
                <img src="https://github.com/user-attachments/assets/7893d174-7e77-4b20-8e43-5ffb2384016c" alt="공공데이터 제공신청 스크린샷" width="">
                
            - 신청 결과 (8월 28일)
                - 행정안전부에서 종합하고 있는 정보가 없다는 답변
                - 각 지방자치단체로 문의 해보는것을 권고
        - **지방자치단체 안전담당과 유선으로 문의 (8월 28일)**
            - 문의 결과 (8월 28일)
                - 지방자치단체에서 종합하고 있는 정보가 없다는 답변
                - 시민제공용 화생방 방독면은 없다는 답변, 개인적으로 구비해야한다.
                - 대원용 화생방용 방독면 정보는 국방 정보로 인해 제공 불가하다는 답변
                - 화재대피용 마스크 정보는 각 지방교통공사로 문의 해보는것을 권고
        - **인천교통공사 대상으로 공공데이터 제공신청 (8월 28일)**
            - 제공신청 화면
                
                <img src="https://github.com/user-attachments/assets/b1646f91-e142-4536-b857-1544a06be662" alt="인천교통공사 제공신청 스크린샷 1" width="">
                
                <img src="https://github.com/user-attachments/assets/43e978d8-7abb-4574-855d-493e63f040f5" alt="인천교통공사 제공신청 스크린샷 2" width="">
                
            - 신청 결과 (9월 3일)
                - 국가핵심기반시설 보안관계로 공개불가 답변
                - 데이터 분쟁조정 신청 [**인천교통공사 대상으로 공공데이터 제공 분쟁조정 신청 (9월 3일)**](https://www.notion.so/9-3-e63f2bec429b491296be07024253e167?pvs=21)
        - **타 지역교통공사 대상으로 공공데이터 제공신청 (9월 2일)**
            - 제공신청 화면
                
                <img src="https://github.com/user-attachments/assets/8bf6e3e6-7806-4660-8465-e066cf257fe8" alt="타 지역교통공사 제공신청 스크린샷" width="">
                
            - 신청 결과
                - 광주교통공사 : 역사내 화재대피용 마스크 미보유로 인한 데이터 제공 불가 답변 (9월 4일)
                    
                    <img src="https://github.com/user-attachments/assets/cd823ee9-a0a0-478e-8e5e-cd994b433a71" alt="광주교통공사 답변 스크린샷" width="">

                    
                - 대전교통공사 : 이메일을 통한 데이터 제공 (9월 9일)
                    
                    
                    <img src="https://github.com/user-attachments/assets/d4804784-3dc2-404d-91f1-a7f7d6efb74a" alt="대전교통공사 답변 스크린샷 1" width="">
                    
                    <img src="https://github.com/user-attachments/assets/b85fd162-a392-4e30-898f-749d51bfbcd6" alt="대전교통공사 답변 스크린샷 2" width="">
                    
                    <img src="https://github.com/user-attachments/assets/18fe86d1-041e-453f-b5a1-ec84674bd6f0" alt="대전교통공사 데이터 제공 이메일 스크린샷" width="">
                    
                - 경기교통공사 : 철도역사를 관리하고 있지않아 데이터 제공 불가 답변 (9월 4일)
                    
                    
                    <img src="https://github.com/user-attachments/assets/1d7818cc-5ba4-48b5-b995-c04ca6219607" alt="경기교통공사 답변 스크린샷 1" width="">
                    
                    <img src="https://github.com/user-attachments/assets/5750dc31-542e-4516-93c6-e6e9eb81a9eb" alt="경기교통공사 답변 스크린샷 2" width="">
                    
                - 서울교통공사 : 역별 보유수량에 대한 재조사 및 현행화가 필요하여 불가 답변 (9월 13일)
                    - 데이터 분쟁조정 신청 [**서울교통공사 대상으로 공공데이터 제공 분쟁조정 신청 (9월 10일)**](https://www.notion.so/9-10-c2885ebdd66a4d7daae106a567036f96?pvs=21)
                    
                    <img src="https://github.com/user-attachments/assets/a66aa22a-9cbf-48e2-9373-3b89fc080f18" alt="서울교통공사 답변 스크린샷 1" width="">
                    
                    <img src="https://github.com/user-attachments/assets/0119c500-0288-40c3-8b78-bf11f1c040d4" alt="서울교통공사 답변 스크린샷 2" width="">
                    
                - 부산교통공사 : 공공데이터 포털에 데이터 신규 개방 (9월 19일)
                    
                    https://www.data.go.kr/data/15136814/fileData.do
                    
                    [부산교통공사_역사 화재용 긴급대피마스크 보유 현황_20230430](https://www.data.go.kr/data/15136814/fileData.do)
                    
                    <img src="https://github.com/user-attachments/assets/32f393c3-e45c-455d-966f-f6e58230a6e5" alt="부산교통공사 답변 스크린샷 1" width="">
                    
                    <img src="https://github.com/user-attachments/assets/fb1354b4-fb4c-4e43-9912-242ebe96473c" alt="부산교통공사 답변 스크린샷 2" width="">
                    
                - 세종도시교통공사 : 철도역사를 관리하고 있지않아 데이터 제공 불가 답변 (9월 4일)
                    
                    
                    <img src="https://github.com/user-attachments/assets/8912f231-6e0d-4d1a-84c7-16b47bdb9616" alt="세종도시교통공사 답변 스크린샷 1" width="">
                    
                    <img src="https://github.com/user-attachments/assets/43db31a4-3838-4b79-9b00-3ef56b1c73d0" alt="세종도시교통공사 답변 스크린샷 2" width="">
                    
        - **인천교통공사 대상으로 공공데이터 제공 분쟁조정 신청 (9월 3일)**
            - 분쟁조정 신청 화면
                
                <img src="https://github.com/user-attachments/assets/2aedaffc-0e65-4abd-a8a4-3e6f9128e75e" alt="인천교통공사 분쟁조정 신청 화면 스크린샷" width="">
                
            - 과정
                - 접수 완료 및 신청 확인 (9월 3일)
                    
                    <img src="https://github.com/user-attachments/assets/46607a8a-0446-4f39-953f-eb500ba637e8" alt="인천교통공사 분쟁조정 접수 완료 메일 스크린샷" width="">
                    
                - 유선 안내 및 신청데이터 특정 및 신청 목적 확인 (9월 9일)
                    
                    <img src="https://github.com/user-attachments/assets/a0969f5b-e3bf-4c49-9246-84dde8f6b524" alt="인천교통공사 분쟁조정 신청데이터 확인 메일 스크린샷" width="">
                    
                - 피신청기관과 데이터 관련 조정 유선 안내 (9월 9일)
                    - 조정 내용
                        - 피신청기관에서 데이터를 보유하고 있지않아 제공에 시일 소요
                        - 위도, 경도, 상세 위치 정보는 제공에 어려움 (추후 개선 요청 가능)
                        - 시스템 구축에 한계가 있어 API 형태로 제공이 어려움
                    - 요청 내용
                        - 조정 내용에 대해서 인지함
                        - 시일이 걸려도 좋으니 정확한 데이터 제공 요청함
                        - 위도, 경도, 상세 위치 정보는 추후 개선 요청함
                    
                - 피신청기관으로 부터 데이터 송달 (9월 20일)
                    
                    <img src="https://github.com/user-attachments/assets/b53afaf6-53d5-4e09-9cac-8a96a83fc027" alt="피신청기관으로 부터 데이터 송달 메일 스크린샷" width="">
                    
                - 조정신청 사건 관련 종료 안내 (9월 25일)
                    
                    <img src="https://github.com/user-attachments/assets/edeefdb4-aa59-4473-9ec5-a230978dab0f" alt="조정신청 사건 관련 종료 안내 메일 스크린샷" width="">
                    
                    [(사전조정)[2024-040]공공데이터제공분쟁조정사건 종결 통보 공문.pdf](https://prod-files-secure.s3.us-west-2.amazonaws.com/83c75a39-3aba-4ba4-a792-7aefe4b07895/8532889a-00dc-46ec-ac94-a04e799ecfab/(%E1%84%89%E1%85%A1%E1%84%8C%E1%85%A5%E1%86%AB%E1%84%8C%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%BC)2024-040%E1%84%80%E1%85%A9%E1%86%BC%E1%84%80%E1%85%A9%E1%86%BC%E1%84%83%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%90%E1%85%A5%E1%84%8C%E1%85%A6%E1%84%80%E1%85%A9%E1%86%BC%E1%84%87%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A2%E1%86%BC%E1%84%8C%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%89%E1%85%A1%E1%84%80%E1%85%A5%E1%86%AB_%E1%84%8C%E1%85%A9%E1%86%BC%E1%84%80%E1%85%A7%E1%86%AF_%E1%84%90%E1%85%A9%E1%86%BC%E1%84%87%E1%85%A9_%E1%84%80%E1%85%A9%E1%86%BC%E1%84%86%E1%85%AE%E1%86%AB.pdf)
                    
        - **서울교통공사 대상으로 공공데이터 제공 분쟁조정 신청 (9월 10일)**
            - 분쟁조정 신청 화면
                
                <img src="https://github.com/user-attachments/assets/60a5589f-d316-4a39-9fb9-731f81f883db" alt="서울교통공사 분쟁조정 신청 화면 스크린샷" width="">
                
            - 과정
                - 접수 완료 및 신청 확인 (9월 10일)
                    
                    <img src="https://github.com/user-attachments/assets/75311065-112c-4bc5-82c3-7337d68a8027" alt="서울교통공사 분쟁조정 접수 완료 메일 스크린샷" width="">
                    
                - 유선 안내 및 신청데이터 특정 및 신청 목적 확인 (9월 10일)
                    
                    <img src="https://github.com/user-attachments/assets/a31978ea-c347-4607-bfdc-95e78b764319" alt="서울교통공사 분쟁조정 신청데이터 확인 메일 스크린샷" width="">
                    
                - 피신청기관과 데이터 관련 조정 유선 안내 (9월 25일)
                    - 조정 내용
                        - 피신청기관에서 최신의 데이터를 보유하고 있지않아 제공에 시일 소요
                        - 위도, 경도, 상세 위치 정보는 제공에 어려움 (추후 개선 요청 가능)
                        - 시스템 구축에 한계가 있어 API 형태로 제공이 어려움
                    - 요청 내용
                        - 조정 내용에 대해서 인지함
                        - 시일이 걸려도 좋으니 정확한 데이터 제공 요청함
                        - 위도, 경도, 상세 위치 정보는 추후 개선 요청함
                    
                - 피신청기관으로 부터 데이터 송달 (9월 26일)
                    
                    <img src="https://github.com/user-attachments/assets/06c76c21-1d32-45d5-aa3b-4944aa042af6" alt="피신청기관으로 부터 데이터 송달 메일 스크린샷" width="">
                    
                - 조정신청 사건 관련 종료 안내 (9월 25일)
                    
                    <img src="https://github.com/user-attachments/assets/e7bdef64-ae34-417a-9f3e-41d52d738b9d" alt="조정신청 사건 관련 종료 안내 메일 스크린샷" width="">
                    
        
        ## 결과 및 프로젝트 반영 / 차선책
        
        ### 문제 해결된 결과
        
        - 제공 가능한 곳에서는 파일데이터 형태(.csv, .cell)를 통해 데이터 제공
        
        ### 향후 계획
        
        - 제공처 마다 데이터 포멧, 내용이 달라 일치화 필요
        - 추후 버전 배포시 서비스 제공 추가
        - 조금 더 다양한 데이터 제공처 찾기
        - 위도, 경도, 상세 위치 정보들이 개선될 경우 서비스 제공 추가
        

## <img src="https://noticon-static.tammolo.com/dgggcrkxq/image/upload/v1602338370/noticon/kmmq4tea9emvc0qcwl0u.png" width="20px"> 앞으로의 계획

### 1차 버그 수정 및 UI 수정

- User Test를 바탕으로 한
    - 버그 개선
    - UI/UX 다듬기
- 코드 리펙토링
- 소셜 로그인 다양화

### 2차 기능 수정

- 데이터 관련
    - 화재대피용 마스크 정보 추가
    - 데이터베이스 최적화
    - 오프라인 데이터 효율적 갱신
- 오프라인 맵 다운로드 기능 추가

### 3차 추가 기능 구현

- **추가 기능**
    - 대피소 네비게이션
    - 커뮤니티 댓글 기능
- **Firebase Analytics 적용**

<!-- ## 7. 구성원 및 역할

---

[김신이조](https://www.notion.so/2db94c64cfe342c9b888bb1dfcec8c66?pvs=21) -->

<!-- <p align="center">
    <img src="" alt="" width="">
</p> -->

<!-- <p align="center">
    <img src="https://github.com/user-attachments/assets/dfe5ae23-0ca6-42d3-b6f7-ae33ec9481ac" alt="app store 6.5.jpg" width="90%"/>
</p> -->
