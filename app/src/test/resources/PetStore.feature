Feature: Pet Store
  Background:
    * def datos = read('datos.json')

  Scenario: Agregar consultar y actualizar Pet
    Given url 'https://petstore.swagger.io/v2/pet'
    And request datos.AddPet
    When method post
    Then status 200
    * def petId = response.id
    * karate.set('petId', petId)
    * print 'Pet ID ingresado: ', karate.get('petId')

    * def IdIngresado = karate.get('petId')
    Given url 'https://petstore.swagger.io/v2/pet/' + IdIngresado
    When method get
    Then status 200
    * def respuestaConsulta = response
    * print 'respuestaConsulta: ', respuestaConsulta
    * match respuestaConsulta.id == IdIngresado

    * respuestaConsulta.name = 'nombre actualizado'
    * respuestaConsulta.status = 'sold'
    Given url 'https://petstore.swagger.io/v2/pet'
    And request respuestaConsulta
    When method put
    Then status 200
    * def respuestaUpdate = response
    * print 'Updated Pet Response: ', respuestaUpdate
    * match respuestaUpdate.name == 'nombre actualizado'
    * match respuestaUpdate.status == 'sold'

    Given url 'https://petstore.swagger.io/v2/pet/findByStatus?status=sold'
    When method get
    Then status 200
    * def respFinal = response
    * print 'respuesta final: ', respFinal

    * def petEncontrado = false
    * karate.forEach(respFinal, function(item) { if (item.name == 'nombre actualizado') { petEncontrado = true }})
    * print 'Pet encontrado: ', petEncontrado