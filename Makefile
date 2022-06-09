up:
	docker compose build --no-cache
	docker compose up -d

out:
	docker-compose down --remove-orphans --volumes
	rm -rf certs
	docker system prune -a -f --volumes

certs:
	docker cp roachcert:/certs/client/client.root.crt .
	docker cp roachcert:/certs/client/client.root.key .
	docker cp roachcert:/certs/client/client.root.key.pk8 .
	docker cp roachcert:/certs/client/ca.crt .

load:
	docker exec -it crdb0 ./cockroach workload init movr --drop --data-loader=import --num-histories=177000 --num-promo-codes=1237 --num-rides=196231 --num-users=13277 --num-vehicles=147 'postgresql://buzz:admin@crdb0:26257'
	docker exec -it -d crdb0 ./cockroach workload run movr --ramp=5m --duration=30m 'postgresql://buzz:admin@crdb0:26257'
	docker exec -it -d crdb1 ./cockroach workload run movr --duration=30m 'postgresql://buzz:admin@crdb1:26257'
	docker exec -it -d crdb2 ./cockroach workload run movr --ramp=3m --duration=30m 'postgresql://buzz:admin@crdb2:26257'
