# Nodejs / 2023/01/02

## Transaction

database 작업에서 a작업이 성공하면 b작업도 성공해야 함을 보장하거나 a-b-c 일련의 순서로 작업이 성공되어야 하는데 중간에 b가 실패하면 앞서 성공했던 a작업도 실패로 처리하고 roll back 시켜야 됨 그럴때 사용하는 기능임 

근데, 몽고에는 transaction 이 없음 . 따라서 Two phase commits 테크닉을 사용해서 transaction 을 수행해야됌 

Fawn 이라는 모듈을 사용해서 Transaction을 구성함 

## Object Id

## Authentication & Authorization

- 둘의 차이
- Register : Post / Login : Post —> why ?? ?
- [https://velog.io/@jch9537/REST-API-LogIn-GET-vs-POST](https://velog.io/@jch9537/REST-API-LogIn-GET-vs-POST)

- lodash : object handling library [https://lodash.com/docs/4.17.15](https://lodash.com/docs/4.17.15)
    
    ```jsx
    user = new User({
    	name : req.body.name,
    	email : req.body.email,
    	passwor : req.body.password
    });
    
    user = new User(_.pick(req.body,['name','email','password']));
    ```
    
- password 강화를 위해 [https://www.npmjs.com/package/joi-password-complexity](https://www.npmjs.com/package/joi-password-complexity)
- hashing password - bcrypt
- JWT - login 시 서버는 JWT 토큰을 주면 됌  → jsonwebtoken 모듈
    
    ```jsx
    const token = jwt.sign({_id: user._id}, 'jwtPrivateKey');
        res.send(token);
    ```
    
    - jwtPrivateKey 는 다른 곳에 저장해야됌
- config 파일로 관리 하기 - config 모듈
    - default.json vs custom-environment-variables.json ??
    - [https://poiemaweb.com/nodejs-keeping-secrets](https://poiemaweb.com/nodejs-keeping-secrets)
    - [https://velog.io/@sksgur3217/Node.JS-React-환경변수-설정](https://velog.io/@sksgur3217/Node.JS-React-%ED%99%98%EA%B2%BD%EB%B3%80%EC%88%98-%EC%84%A4%EC%A0%95)
- header 에 커스텀 필드 setting : `res.header('x-auth-token',token)`
- router 단에서 token을 생성할 경우 나중에 바꿔야할 때 많은 파일을 수정해야하므로,
- 관습적인 패턴은 Model의 메서드로 토큰을 생성해주도록 하자

```jsx
userSchema.methods.generateAuthToken =function(){
consttoken = jwt.sign({_id:this._id}, config.get('jwtPrivateKey'));
returntoken;
}
```

- jwt토큰을 header에 심어서 보내는 방법
    - 각 api의 endpoint 두번째 인자로 밑의 auth 함수를 등록해주면 됨
    - 
    
    ```jsx
    /middleware/auth.js
    
    function auth(req,res,next){
       const token = req.header('x-auth-token');
       if(!token) return res.send(401).send('Access Denied. no token provided.');
    
       try{
           const decoded = jwt.verify(token, config.get('jwtPrivateKey'));
           req.user = decoded;
           next();
       }
       catch (e) {
            res.status(400).send("Invalid Token. ");
       }
    }
    
    ... 
    
    /routes/blah.js
    const auth = require(../middleware/auth.js)
    router.get('/me',[auth] ,(req, res) => {
    		// 여러개의 middleware를 둘 수 있다. 
    });
    ```
