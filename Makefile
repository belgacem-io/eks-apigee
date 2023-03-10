up:
	docker compose up -d

build:
	docker compose build

gen:
	docker compose exec terraform bash -c 'terraform -chdir=/wks/main-orga output -json > /tmp/tf.output'
	docker compose exec terraform bash -c 'for f in $$(find /wks/main-$(filter-out $@,$(MAKECMDGOALS)) -maxdepth 3 -type f -name "*.j2"); do j2 -f json $${f} /tmp/tf.output > $${f/.j2/} ; done'

init:
	docker compose exec terraform bash -c '. /wks/.auth/env && terraform -chdir=/wks/main-$(filter-out $@,$(MAKECMDGOALS)) init'

plan:
	docker compose exec terraform bash -c '. /wks/.auth/env && terraform -chdir=/wks/main-$(filter-out $@,$(MAKECMDGOALS)) plan'

apply:
	docker compose exec terraform bash -c '. /wks/.auth/env && terraform -chdir=/wks/main-$(filter-out $@,$(MAKECMDGOALS)) apply'

destroy:
	docker compose exec terraform bash -c '. /wks/.auth/env && terraform -chdir=/wks/main-$(filter-out $@,$(MAKECMDGOALS)) destroy'

output:
	docker compose exec terraform bash -c '. /wks/.auth/env && terraform -chdir=/wks/main-$(filter-out $@,$(MAKECMDGOALS)) output'

aws:
	docker compose exec terraform bash -c '. /wks/.auth/env && aws ec2 describe-instance-types'

docs:
	docker compose exec terraform bash -c 'for f in $$(find /wks -maxdepth 3 -type f -name "main.tf"); do cd $${f/main.tf/} && terraform-docs markdown table --config /wks/.terraform-docs.yml --output-file README.md  $${f/main.tf/} ; done;'

exec:
	docker compose exec -it -w /wks terraform bash

%: # Unknown targets