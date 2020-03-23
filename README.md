# 설명
.proto 파일을 gRPC 에서 사용가능한 php stub 파일로 생산하는 도구 입니다.

**참고**
https://grpc.io/docs/quickstart/php/

# 실행 방법
1. .proto 파일 작성
2. docker 실행시 .proto 파일 경로 마운트
3. 아래 제공되는 커맨드를 통해 stub 파일 생성

``` bash
# 이미지 실행
docker run -it --rm -v ${local directory}:/proto \
    lejewk/proto-gen-grpc-php7.0.12 bash
    

# stub 파일 생성
protoc --proto_path=/proto \
  --php_out=/proto \
  --grpc_out=/proto \
  --plugin=protoc-gen-grpc=/grpc/bins/opt/grpc_php_plugin \
  ${proto_filename}
```

# 예시
``` bash
# 동일 경로의 proto 디렉토리 마운트
# proto 디렉토리 내에는 helloworld.proto 파일이 존재합니다.
docker run -it --rm -v "$(pwd -W)"/proto:/proto \
    lejewk/proto-gen-grpc-php7.0.12 bash

# 컨테이너 내부에서 아래 커맨드를 통해 stub 파일 생성
protoc --proto_path=/proto \
  --php_out=/proto \
  --grpc_out=/proto \
  --plugin=protoc-gen-grpc=/grpc/bins/opt/grpc_php_plugin \
  /proto/helloworld.proto
```