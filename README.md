# Interrupt Affinity를 통한 Core 지정 연구

두 종류의 Edge device(Rasberry Pi, Jetson orin nano)에서 메시지 크기와 CPU Core에 따른 네트워크 성능 분석을 진행한 결과 Interrupt Affinty에 따라 Network Throughput 차이가 높게 나타나는 것을 확인할 수 있었음 

이를 통해 처리량이 높게 측정되는 코어로 네트워크 처리를 바인딩하여 전체적인 네트워크 성능을 높이는 연구를 진행

Network Interrupt가 처리되는 코어를 확인한 후 이를 제외한 코어에서 네트워크 작업 처리가 이루어지도록 하는 스크립트 작성
	
