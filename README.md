# Vending Machine Code Test for CleoAI


### Description

I have approached the coding test by modeling the machine as a Finite State
Automata (FSM).  I have chosen AASM gem to implement the state machine.
The state machine describes the solution in a more formal way.  Its operation
is easier to explain and understand using the diagram below.


Notes:
* Each story is validated by one of the tests
* Change class accepts denomination values as specified in the story, e.g. '1p', '50p', '£1'
* The implementation is located in `app/models` folder while `vending_machine.rb`
  file contains logic of the machine itself
* The tests are located in `spec/models/vending_machine_spec.rb` spec file


### Execution

The project has been implemented in Rails framework using a template from
a different project of mine to save on time setting up a boiler plate.
The project is dockerized hence the tests can be executed as follows,

```
cd vending_machine/
docker-compose up
docker-compose exec app su app
bin/rspec spec/models/vending_machine_spec.rb
```


### Improvements:

* Vend only and only if there is enough collected and inserted change to make the refund
* Validate product and change input parameters

* Vending Machine can be created with a security key to protect access to
  the internal content of the change collected and operations of loading
  products and change
