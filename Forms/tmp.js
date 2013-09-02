var myjson = null;
var relatedTmp = null;
window.onload = function () {

	$("select").change(function (e) {
					   var mainselect = $(this);
					   console.log("ENTRO A LA FUNCION");
					   var prop = $(this).attr('xd:binding');
					   console.log("binding: " + prop);
					   var i = $(this).attr('xd:binding').indexOf('RW/my:');
					   console.log("i: " + i);
					   var rel = $(this).attr('xd:binding').substring(i + 6);
					   console.log("rel: " + rel);
					   $("select").each(function () {
										
										if($(this).attr('relatedproperty') == rel){
										relatedTmp = $(this);
										console.log(relatedTmp);
										var data = $(this).attr('relationshipmember') + '_' + $(this).attr('relatedproperty');
										console.log(data);
										$(this).empty();
										console.log('1');
										var iframe = document.createElement("IFRAME");
																				console.log('2');
										iframe.setAttribute("width", "1");
																				console.log('3');
										iframe.setAttribute("height", "1");
																				console.log('4');
										console.log(data + " | " + mainselect.val());
										iframe.setAttribute("src", "js-frame:load_related:" + data + "$" + mainselect.val());
																				console.log('5');
										document.documentElement.appendChild(iframe);
										iframe.parentNode.removeChild(iframe);
										iframe = null;
										}
										});
					   });
    if (isIphone) {
        var iframe = document.createElement("IFRAME");
        setInputEnabled();
    } else {
        AndroidFunction.cargarDatos();
    }

}
var currentId = -1;
var maxid = -1;
var isIphone = false;

function related_data(data){
	console.log('1');
	myjson = JSON.parse(data);
	console.log('2');
	relatedTmp.append(new Option("",""));
	console.log('3');
	for	(var i=0;i<myjson.length;i++){
		var obj = myjson[i];
		relatedTmp.append(new Option(obj.text,obj.valor));
	}
	var options = relatedTmp.find('option');
    var arr = options.map(function(_, o) {
						  return {
						  t: $(o).text(),
						  v: o.value
						  };
						  }).get();
    arr.sort(function(o1, o2) {
			 return o1.t > o2.t ? 1 : o1.t < o2.t ? -1 : 0;
			 });
    options.each(function(i, o) {
				 console.log(i);
				 o.value = arr[i].v;
				 $(o).text(arr[i].t);
				 });
}
function setFecha(e) {
    if (!isIphone) {
        currentId = e.id;
        AndroidFunction.openDatePickerDialog();
    }
}

function setInputEnabled() {
    var inputs = document.getElementsByTagName("input");
    for (var i = 0; i < inputs.length; i++) {
        if (inputs[i].getAttribute("type") == "date") {
            inputs[i].removeAttribute("readonly");
        }
    }
}

function mostrarFecha(date) {
    document.getElementById(currentId).value = date;
}

function obtainMaxID() {
    var metaTags = document.getElementsByTagName("meta");
    for (var i = 0; i < metaTags.length; i++) {
        if (metaTags[i].getAttribute("property") == "maxid") {
            maxid = metaTags[i].getAttribute("content");
            break;
        }
    }
}

function setIphone() {
    isIphone = true;
    console.log("IPHONE SETEADO");
}

function save() {
    var metaTags = document.getElementsByTagName("meta");
    var data = "<?xml version='1.0' ?><formData>";

    for (var i = 0; i < metaTags.length; i++) {
        if (metaTags[i].getAttribute("property") == "maxid") {
            maxid = metaTags[i].getAttribute("content");
            break;
        }
    }

    for (var i = 0; i < maxid; i++) {
        var element = document.getElementById("" + i);
        if (element.getAttribute("type") != "button") {
            var xdBinding = element.getAttribute("xd:binding");
			var idx = xdBinding.indexOf("RW/my:");
			if(idx > -1) {
				console.log("binding: " + xdBinding);
				var nodeName = xdBinding.substring(idx + 6);
				console.log("node_name: " + nodeName);
				var nodeValue = element.value;
				console.log("node_value: " + nodeValue);
				data = data + "<" + nodeName + " id='" + i + "'>" + nodeValue + "</" + nodeName + ">";

			} else {
				console.log("binding: " + xdBinding);
				var nodeName = xdBinding.substring(3);
				console.log("node_name: " + nodeName);
				var nodeValue = element.value;
				console.log("node_value: " + nodeValue);
				data = data + "<" + nodeName + " id='" + i + "'>" + nodeValue + "</" + nodeName + ">";
			}
        }

    }

    data = data + "</formData>";
    if (isIphone) {
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("width", "1");
        iframe.setAttribute("height", "1");
        iframe.setAttribute("src", "js-frame:save:" + data);
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    } else {
        AndroidFunction.saveXML(data);
    }
}

function loadData(json) {
    try {
        console.log("ENTRA ACA");
        obtainMaxID();

        var jsonData = JSON.parse(json);
        console.log(jsonData);
        for (var i = 0; i < jsonData.length; i++) {
            var id = jsonData[i].guid;
            var value = jsonData[i].valor;
            var element = document.getElementById(id);
            console.log(id);
            if (element.getAttribute("type") != "button") {
                if (element.getAttribute("xd:xctname") == "dropdown") {
                    var optionList = element.options;
                    for (var j = 0; j < optionList.length; j++) {
                        if (optionList[j].value == value) {
                            element.selectedIndex = j;
                            break;
                        }
                    }
                } else {
                    element.value = value;
                }
            }
        }
    } catch (err) {
        console.log(err);
    }
}