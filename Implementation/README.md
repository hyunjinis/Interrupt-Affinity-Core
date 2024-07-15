# Interrupt Affinity Core Script 구현
모든 기기들은 Interrupt Affinity에 따라 네트워크 인터럽트를 처리하는 코어가 지정되어 있다. 

해당 코어에서 네트워크 작업 처리가 이루어진다면 인터럽트 처리와 네트워크 작업 처리 간의 CPU 경합이 발생하여 
