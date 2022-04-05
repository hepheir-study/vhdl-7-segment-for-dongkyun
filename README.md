동균이의 조 번호: 15조


* 위의 2개의 소스코드를 구현하여 동작을 확인한다.
* 위의 2개의 소스코드를 이해하여 7세그먼트의 표시가 **자신의 조 번호 + 10** 에서 시작 하여 **우측 키를 누를때 마다 하나식 줄어서 0이 되면 다시 원래의 초기값이** 되도록 구성 하세요. 이에 대한 소스코드를 결과 내용으로 작성하고 추가 혹은 변경한 부분은 **주석으로 설명하세요**.

* 위의 내용이 동작되는 장면을 동영상 촬영하여 **첨부 제출하세요**.


## VHDL

<https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=pcs874&logNo=60102113044>

우선 VHDL에서는 하드웨어의 선(wire)를 signal 이라는 걸로 표현합니다.

그래서 시그널을 선언을 할 때는 다음과 같이 써 줘야 합니다.

```vhdl
signal A,B : bit;
```

맨앞에는 signal이라고 쓰고 그다음은 시그널의 이름 그다음음은 데이터 타입순으로 씁니다.


- integer : 정수의 값을 가지는 데이터 타입

```vhdl
signal A : integer range 0 to 7;
signal B : integer range 15 downto 0;
```

```vhdl
signal A;

C <= (A <= "11100000");

```

$A \leq 11110000$ (x)
$$
\text{assume A is } 11110000

$$
