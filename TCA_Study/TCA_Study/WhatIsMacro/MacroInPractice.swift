//
//  MacroInPractice.swift
//  TCA_Study
//
//  Created by KYUBO A. SHIM on 12/27/23.
//

import Foundation

/**
 Tuple 로, 중복 코드 형태이다.
 */
let calculations = [
    (1 + 1, "1 + 1"),
    (2 + 3, "2 + 3"),
    (7 - 3, "7 - 3"),
    (5 - 2, "5 - 2"),
    (3 * 2, "3 * 2"),
    (3 * 5, "3 * 5")
]

/// 이거를 Swift Macro 로 단순화한 형태로 바꿔보자
/// Compile 타임에 정해지고, 중복 코드가 많이 개선됨
/*
let calculationsWithMacro = [
    #stringfy(1 + 1),
    #stringfy(2 + 3),
    #stringfy(7 - 3),
    #stringfy(5 - 2),
    #stringfy(3 * 2),
    #stringfy(3 * 5)
]
 */

/** 이제 만들어보자!
 1. 키워드를 먼저 작성한다.
    - @freestanding -> "사용시에 # 으로 시작"
        a. @freestanding(expression): 미리 정의한 값 반환
        b. @freestanding(declaration): 특정 인수를 받아서 처리
    - @attached -> "사용시에 @ 으로 시작"
        a. @attached(peer): 적용되는 선언과 함께 새 선언을 추가
        b. @attached(accessor): property 에 get, set, willSet, didSet 과 같은 접근자를 추가하는 매크로
        c. @attached(memberAttribute): property wrapper 처럼 사용하며, 각 property 에 일괄 적용하여 생략 가능하게 사용 가능한 방법
        d. @attached(member): 기존에는 기존의 멤버에 새로운 특성을 추가했지만, @attached(member) 는 완전히 새로운 멤버를 추가
            (여기서 member 란, method, property, initializer)
        e. @attached(conformance): 적용되는 유형/확장에 적합성을 자동으로 추가
*/

/// 해당 Macro 는 호출되면, Swift Compiler 는 해당 Macro 에 대한 구현이 있는 Compiler plugin 으로 해당 Macro 를 달라는 형태로 요청한다.
///  그래서 현재 이상태로만 둔다면, 에러가 발생한다.
/// ❗️"Macro 'stringfy' requires a definition"

/// 이때, Compiler Plugin 은 보안 Sandbox 별도의 프로세스로 실행을 한다.
///   - 일어나는 순서는 다음과 같다.
/// 1. Swift Complier 가 Compiler Plugin 에 Macro 구현에 대한 요청
/// 2. Compiler Plugin 은 Macro 사용을 처리하고 Macro 에 의해 생성된 새로운 코드 조각인 "expansion" 을 반환한다.
/// 3. Swift Compiler 에서 "expansion" 을 받으면, Swift Compiler 가 expansion 을 프로그램에 추가하고 코드의 확장을 함께 컴파일한다.
/*
 @freestanding(expression)
macro stringfy(_ value: Int) -> (Int, String)
 */


/**
 Macro Plugin 이란, Swift Macro 를 구현하는 부분을 의미한다.
 - pound: 매크로를 정의한다는 의미
 - identifier(" "): 매크로의 이름
 - leftParen, rightParen: 각 매크로의 동작을 표현
 
 가장 좋은 점:
 Macro 구현 자체가 Swift 로 작성된 프로그램이며, 원하는 구문 트리로의 변환을 수행할 수 있다.
 */
