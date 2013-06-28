casper = require('casper').create()
x = require('casper').selectXPath

config_url = 'http://smorodina.com:1331/'
url_place = 'places/147'
url_object = 'objects/vodopad'
timeout = 5000

#User login
casper.start config_url, ->
  casper.viewport 1024, 768
  console.log 'User login'
  @click '#show_registration_modal'
  @evaluate -> document.querySelector('#user_login_email').value = email
  @evaluate -> document.querySelector('#user_login_password').value = passwd
  @click '#login'
  @wait timeout, ->
    @echo "-wait for loging"

#Open object's page and click link of place
casper.thenOpen config_url + url_object, ->
  console.log("Open object's page")
  @click(x("//ul[@class='smorodina-item__geo__list']/li[last()]/a"), "-click place's url")
  @wait timeout, ->
    @test.assertUrlMatch(url_place, "-URL of place is correct")

#Open place's page and verify objects
casper.thenOpen config_url + url_place, ->
  console.log("Open place's page")
  @test.assertVisible('h1')
  @test.assertVisible('ul.smorodina-item__geo__list')
  @test.assertVisible('div#searchCategories')
  @test.assertVisible('div#searchResultsPanel')
  @test.assertVisible('div.events_section')

#Sort objects on place's page
casper.thenOpen config_url + url_place, ->
  console.log("Sorting objects on place's page")
  @click(x("//div[@class='search-results-panel__inner']//span[contains(@class, 'by_name')]"), '-sort by name')
  @wait timeout, ->
    @test.assertExists(x("//div[@id='place_object_list']/div[@class='smorodina-item'][1]//div[@class='smorodina-item__title']/a/b[text()='ЮниКредит']"), 'ЮниКредит is first after sorting')
    @test.assertExists(x("//div[@id='place_object_list']/div[@class='smorodina-item'][last()]//div[@class='smorodina-item__title']/a/b[text()='GE Money Bank']"), 'GE Money Bank is last after sorting')
  @click(x("//div[@class='search-results-panel__inner']//span[contains(@class, 'by_name')]"), '-sort by name')
  @wait timeout, ->
    @test.assertExists(x("//div[@id='place_object_list']/div[@class='smorodina-item'][last()]//div[@class='smorodina-item__title']/a/b[text()='ЮниКредит']"), 'ЮниКредит is last after sorting')
    @test.assertExists(x("//div[@id='place_object_list']/div[@class='smorodina-item'][1]//div[@class='smorodina-item__title']/a/b[text()='GE Money Bank']"), 'GE Money Bank is first after sorting')

casper.run ->
  @exit()
