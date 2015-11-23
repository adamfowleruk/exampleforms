xquery version "1.0-ml";
declare namespace html = "http://www.w3.org/1999/xhtml";
<results>
{
let $node := <countries>
	<region name="Rest of UK">
	  <country label="England">
	  	<name>England</name>
	  </country>
	  <country label="Wales">
	  	<name>Wales</name>
	  </country>
	  <country label="Northern Ireland">
	  	<name>Northern Ireland</name>
	  </country>
	  <country label="UK Continental Shelf">
	  	<name>UK Continental Shelf</name>
	  </country>
	</region>
	<region name="Rest of EU">
		<country label="Austria">
	      <name>Austria</name>
		</country>
		<country label="Belgium">
			<name>Belgium</name>
		</country>
		<country label="Bulgaria">
			<name>Bulgaria</name>
		</country>
		<country label="Croatia">
			<name>Croatia</name>
		</country>
		<country label="Cyprus">
			<name>Cyprus</name>
		</country>
		<country label="Czech Republic">
			<name>Czech Republic</name>
		</country>
		<country label="Denmark">
			<name>Denmark</name>
		</country>
		<country label="Eire">
			<name>Eire</name>
		</country>
		<country label="Estonia">
			<name>Estonia</name>
		</country>
		<country label="Finland">
			<name>Finland</name>
		</country>
		<country label="France">
			<name>France</name>
		</country>
		<country label="Germany">
			<name>Germany</name>
		</country>
		<country label="Greece">
			<name>Greece</name>
		</country>
		<country label="Hungary">
			<name>Hungary</name>
		</country>
		<country label="Italy>">
			<name>Italy</name>
		</country>
		<country label="Latvia">
			<name>Latvia</name>
		</country>
		<country name="Lithuania">
			<name>Lithuania</name>
		</country>
		<country label="Luxembourg">
			<name>Luxembourg</name>
		</country>
		<country label="Malta">
			<name>Malta</name>
		</country>
		<country label="Netherlands">
			<name>Netherlands</name>
		</country>
		<country label="Poland">
			<name>Poland</name>
		</country>
		<country label="Portugal">
			<name>Portugal</name>
		</country>
		<country label="Romania">
			<name>Romania</name>
		</country>
		<country label="Slovak Republic">
			<name>Slovak Republic</name>
		</country>
		<country label="Slovenia">
			<name>Slovenia</name>
		</country>
		<country label="Spain">
			<name>Spain</name>
		</country>
		<country label="Sweden">
			<name>Sweden</name>
		</country>
	</region>	
	<region name="Rest of World">
		<region name="Rest of Europe">
			<country label="Albania">
				<name>Albania</name>
			</country>
			<country label="Andorra">
				<name>Andorra</name>
			</country>
			<country label="Armenia">
				<name>Armenia</name>
			</country>
			<country label="Azerbaijan">
				<name>Azerbaijan</name>
			</country>
			<country label="Belarus">
				<name>Belarus</name>
			</country>
			<country label="Bosnia-Herzegovina">
				<name>Bosnia-Herzegovina</name>
			</country>
			<country label="Channel Islands">
				<name>Channel Islands</name>
			</country>
			<country label="Faroe Islands">
				<name>Faroe Islands</name>
			</country>
			<country label="Republic of Macedonia">
				<name>Republic of Macedonia</name>
			</country>
			<country label="Georgia">
				<name>Georgia</name>
			</country>
			<country label="Gibraltar">
				<name>Gibraltar</name>
			</country>
			<country label="Iceland">
				<name>Iceland</name>
			</country>
			<country label="Isle of Man">
				<name>Isle of Man</name>
			</country>
			<country label="Kosovo">
				<name>Kosovo</name>
			</country>
			<country label="Liechtenstein">
				<name>Liechtenstein</name>
			</country>
			<country label="Moldova">
				<name>Moldova</name>
			</country>
			<country label="Monaco">
				<name>Monaco</name>
			</country>
			<country label="Montenegro">
				<name>Montenegro</name>
			</country>
			<country label="Norway">
				<name>Norway</name>
			</country>
			<country label="Russia">
				<name>Russia</name>
			</country>
			<country label="Serbia">
				<name>Serbia</name>
			</country>
			<country label="Switzerland">
				<name>Switzerland</name>
			</country>
			<country label="Turkey">
				<name>Turkey</name>
			</country>
			<country label="Ukraine">
				<name>Ukraine</name>
			</country>
		</region>
		<region name="North America">
			<country label="Canada">
				<name>Canada</name>
			</country>
			<country label="Greenland">
				<name>Greenland</name>
			</country>
			<country label="USA incl. Puerto Rico">
				<name>USA incl. Puerto Rico</name>
				<name>Puerto Rico</name>
				<name>United States of America</name>
			</country>
		</region>
		<region name="Central/ South America">
			<country label="Argentina">
				<name>Argentina</name>
			</country>
			<country label="Brazil">
				<name>Brazil</name>
			</country>
			<country label="Caribbean Islands">
				<name>Caribbean Islands</name>
				<name>Anguilla</name>
				<name>Antigua &amp; Barbuda</name>
				<name>Aruba</name>
				<name>Bahamas</name>
				<name>Barbados</name>
				<name>Bermuda</name>
				<name>Caymans</name>
				<name>Cuba</name>
				<name>Dominica</name>
				<name>Dominican Rep.</name>
				<name>Dutch Antilles</name>
				<name>Grenada</name>
				<name>Haiti</name>
				<name>Jamaica</name>
				<name>Montserrat</name>
 				<name>St Kitts &amp; Nevis</name>
 				<name>St Lucia</name>
 				<name>St Vincent &amp; Grenadines</name>
 				<name>Trinidad &amp; Tobago</name>
 				<name>Turks &amp; Caicos</name>
 				<name>Virgin Is.</name>
 				<name>West Indies</name>
			</country>
			<country label="Chile">
				<name>Chile</name>
			</country>
			<country label="Colombia">
				<name>Colombia</name>
			</country>
			<country label="Mexico">
				<name>Mexico</name>
			</country>
			<country label="Peru">
				<name>Peru</name>
			</country>
			<country label="Uruguay">
				<name>Uruguay</name>
			</country>
			<country label="Venezuela">
				<name>Venezuela</name>
			</country>
			<country label="Other Central America">
				<name>Belize</name>
				<name>Costa Rica</name>
				<name>El Salvador</name>
				<name>Guatemala</name>
				<name>Honduras</name>
				<name>Panama</name>
				<name>Nicaragua</name>
			</country>
			<country label="Other South America">
				<name>Bolivia</name>
				<name>Ecuador</name>
				<name>Falklands</name>
				<name>French Guiana</name>
				<name>Guyana</name>
				<name>Paraguay</name>
				<name>Suriname</name>
			</country>
		</region>
		<region name="Australasia">
			<country label="Australia">
				<name>Australia</name>
			</country>
			<country label="New Zealand">
				<name>New Zealand</name>
			</country>
			<country label="Pacific Islands">
				<name>Pacific Islands</name>
				<name>Fiji</name>
				<name>Tonga</name>
				<name>Samoa</name>
				<name>New Caledonia</name>
				<name>Cook Islands</name>
				<name>Vanuato</name>
				<name>Papua New Guinea</name>
			</country>
		</region>
		<region name="Middle East">
			<country label="Bahrain">
				<name>Bahrain</name>
			</country>
			<country label="Egypt">
				<name>Egypt</name>
			</country>
			<country label="Iran">
				<name>Iran</name>
			</country>
			<country label="Iraq">
				<name>Iraq</name>
			</country>
			<country label="Israel / Pal. areas">
				<name>Israel / Pal. areas</name>
			</country>
			<country label="Jordan">
				<name>Jordan</name>
			</country>
			<country label="Kuwait">
				<name>Kuwait</name>
			</country>
			<country label="Lebanon">
				<name>Lebanon</name>
			</country>
			<country label="Libya">
				<name>Libya</name>
			</country>
			<country label="Oman">
				<name>Oman</name>
			</country>
			<country label="Qatar">
				<name>Qatar</name>
			</country>
			<country label="Saudi Arabia">
				<name>Saudi Arabia</name>
			</country>
			<country label="Sudan">
				<name>Sudan</name>
			</country>
			<country label="Syria">
				<name>Syria</name>
			</country>
			<country label="UAE">
				<name>UAE</name>
				<name>United Arab Emirates</name>
				<name>Abu Dhabi</name>
				<name>Dubai</name>
				<name>Fujairah</name>
				<name>Sharjah</name>
				<name>Ajman</name>
				<name>Umm Al-Qaiwain</name>
				<name>Ras Al-Khaimah</name>
			</country>
			<country label="Yemen">
				<name>Yemen</name>
			</country>
			<country label="Other Middle East">
				<name>Other Middle East</name>
			</country>
		</region>
		<region name="Africa">
			<country label="Algeria">
				<name>Algeria</name>
			</country>
			<country label="Angola">
				<name>Angola</name>
			</country>
			<country label="Botswana">
				<name>Botswana</name>
			</country>
			<country label="Equatorial Guinea">
				<name>Equatorial Guinea</name>
			</country>
			<country label="Ghana">
				<name>Ghana</name>
			</country>
			<country label="Kenya">
				<name>Kenya</name>
			</country>
			<country label="Malawi">
				<name>Malawi</name>
			</country>
			<country label="Mauritius">
				<name>Mauritius</name>
			</country>
			<country label="Morocco">
				<name>Morocco</name>
			</country>
			<country label="Nigeria">
				<name>Nigeria</name>
			</country>
			<country label="South Africa">
				<name>South Africa</name>
			</country>
			<country label="Tunisia">
				<name>Tunisia</name>
			</country>
			<country label="Zimbabwe">
				<name>Zimbabwe</name>
			</country>
			<country label="Other Africa">
				<name>Benin</name>
				<name>Burkina Faso</name>
				<name>Burundi</name>
				<name>Cameroon</name>
				<name>Cape Verde Islands</name>
				<name>Central African Rep</name>
				<name>Ceuta</name>
				<name>Chad</name>
				<name>Comoros</name>
				<name>Congo</name>
				<name>Dem Rep Congo</name>
				<name>Djibouti</name>
				<name>Eritrea</name>
				<name>Ethiopia</name>
				<name>Gabon</name>
				<name>Gambia</name>
				<name>Guinea</name>
				<name>Guinea-Bissau</name>
				<name>Ivory Coast</name>
				<name>Lesotho</name>
				<name>Liberia</name>
				<name>Madagascar</name>
				<name>Mali</name>
				<name>Mauritania</name>
				<name>Mayotte</name>
				<name>Melilla</name>
				<name>Mozambique</name>
				<name>Namibia</name>
				<name>Niger</name>
				<name>Rwanda</name>
				<name>Sao Tome and Principe Senegal</name>
				<name>Seychelles</name>
				<name>Sierra Leone</name>
				<name>Somalia</name>
				<name>St Helena</name>
				<name>Sudan</name>
				<name>Swaziland</name>
				<name>Tanzania</name>
				<name>Togo</name>
				<name>Uganda</name>
				<name>Zambia</name>
			</country>
		</region>			
		<region name="Asia">
			<country label="Bangladesh">
				<name>Bangladesh</name>
			</country>
			<country label="Brunei">
				<name>Brunei</name>
			</country>
			<country label="China">
				<name>China</name>
			</country>
			<country label="Hong Kong">
				<name>Hong Kong</name>
			</country>
			<country label="India">
				<name>India</name>
			</country>
			<country label="Indonesia">
				<name>Indonesia</name>
			</country>
			<country label="Japan">
				<name>Japan</name>
			</country>
			<country label="Kazakhstan">
				<name>Kazakhstan</name>
			</country>
			<country label="Malaysia">
				<name>Malaysia</name>
			</country>
			<country label="Pakistan">
				<name>Pakistan</name>
			</country>
			<country label="Philippines">
				<name>Philippines</name>
			</country>
			<country label="Singapore">
				<name>Singapore</name>
			</country>
			<country label="South Korea">
				<name>South Korea</name>
			</country>
			<country label="Sri Lanka">
				<name>Sri Lanka</name>
			</country>
			<country label="Taiwan">
				<name>Taiwan</name>
			</country>
			<country label="Thailand">
				<name>Thailand</name>
			</country>
			<country label="Vietnam">
				<name>Vietnam</name>
			</country>
			<country label="Other Central Asia">
				<name>Turkmenistan</name>
				<name>Uzbekistan</name>
				<name>Kyrgyzstan</name>
				<name>Tajikistan</name>
				<name>Afghanistan</name>
				<name>Mongolia</name>
			</country>
			<country label="Other South Asia">
				<name>Maldives</name>
				<name>Nepal</name>
				<name>Bhuta</name>
			</country>
			<country label="Other Southeast Asia">
				<name>Cambodia</name>
				<name>Far East</name>
				<name>Laos</name>
				<name>Myanmar /Burma</name>
				<name>North Korea</name>
			</country>
		</region>
	</region>
</countries>
let $query := xdmp:get-request-field("query")
for $name in $node//region[@name != "Rest of UK"]//country/name[matches(., $query, 'i')]
let $label := $name/text()
let $value := $name/../@label/string()
return <result><label>{$label}</label><value>{$value}</value></result>
}
</results>