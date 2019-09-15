// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage

//= require cocoon


//= require bootstrap-sprockets
//= require_tree .

$(function() {
    $('.a').slick({
        dots: true,
    });
});


$(function() {
  $(document).on('click', '#post_fav a', function() {
    if ($('a').val() == '') {
      return false;
    }
  });
  $(document).on('ajax:success', '#post_fav a', function(e) {
    console.log(e.detail[0][0]);
    if (e.detail[0][0].done == "save"){
        var post_fav = document.getElementById('post_fav')
        post_fav.innerHTML = '<a class="post_fav_deatroy" data-remote="true" rel="nofollow" data-method="delete" href="/lincoln_riders/users/'+e.detail[0][0].user_id+'/posts/'+e.detail[0][0].post_id+'/post_favs"><i class="fa fa-heart" aria-hidden="true" style="color:red;"></i></a>'
    }
    if (e.detail[0][0].done == "destroy"){
        var post_fav = document.getElementById('post_fav')
        post_fav.innerHTML = '<a class="post_fav_create" data-remote="true" rel="nofollow" data-method="post" href="/lincoln_riders/users/'+e.detail[0][0].user_id+'/posts/'+e.detail[0][0].post_id+'/post_favs"><i class="fa fa-heart" aria-hidden="true"></i></a>'
    }
  });

    $(document).on('ajax:success', '#mapped_images_fav a', function(e) {
    console.log(e.detail[0][0]);
    if (e.detail[0][0].done == "save"){
        var mapped_images_fav = document.getElementById('mapped_images_fav')
        mapped_images_fav.innerHTML = '<a class="mapped_images_fav_deatroy" data-remote="true" rel="nofollow" data-method="delete" href="/lincoln_riders/users/'+e.detail[0][0].user_id+'/mapped_images/'+e.detail[0][0].mapped_image_id+'/mapped_images_favs"><i class="fa fa-heart" aria-hidden="true" style="color:red;"></i></a>'
    }
    if (e.detail[0][0].done == "destroy"){
        var mapped_images_fav = document.getElementById('mapped_images_fav')
        mapped_images_fav.innerHTML = '<a class="mapped_images_fav_create" data-remote="true" rel="nofollow" data-method="post" href="/lincoln_riders/users/'+e.detail[0][0].user_id+'/mapped_images/'+e.detail[0][0].mapped_image_id+'/mapped_images_favs"><i class="fa fa-heart" aria-hidden="true"></i></a>'
    }
  });

});

var GetMapForMyPage = (function() {
  function codeAddress(mapped_image_id,mapped_image_positions,address,mapped_image_position_size) {
    // google.maps.Geocoder()コンストラクタのインスタンスを生成
    var geocoder = new google.maps.Geocoder();

    // 地図表示に関するオプション
    var mapOptions = {
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    // 地図を表示させるインスタンスを生成
    var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    //マーカー変数用意
    var marker;
    var infoWindow;
    var showing_mapped_image_id;

        // マーカー設定
        marker = new google.maps.Marker({
          map: map,
          position: mapped_image_positions[0] //results[0].geometry.location = (lat,lng)
        });

        infoWindow = new google.maps.InfoWindow({ // 吹き出しの追加
          content: "お待ちください"    // 吹き出しに表示する内容
        });


        markerEvent(mapped_image_id[0]);
        $(".mapped_image_field_0").css('background-color','lightgray');

    function markerEvent(mapped_image_id) {
      marker.addListener('click', function() { // マーカーをクリックしたとき

              $.ajax({
                url: "/lincoln_riders/mapped_images/get_window_content",
                type: "GET",
                data: { showing_mapped_image_id : mapped_image_id
                        },
                dataType: "json",
                success: function(data) {
                  console.log("ajax成功");
                  infoWindow.setContent( '<div>'+data.text+'</div>'+
                                            '<img class="attachment mapped_image image" src="'+data.image_id+'">' ) ;
                  infoWindow.open(map, marker); // 吹き出しの表示
                },
                error: function(){
                  console.log('ajax失敗');
                },
              })
      });
    }

    geocoder.geocode( { 'address': address}, function(results, status) {

      // ジオコーディングが成功した場合
      if (status == google.maps.GeocoderStatus.OK) {

        // 変換した緯度・経度情報を地図の中心に表示
        map.setCenter(results[0].geometry.location);

      // ジオコーディングが成功しなかった場合
      } else {
        console.log('Geocode was not successful for the following reason: ' + status);
      }
      console.log(results)
    });

      // マップをクリックで位置変更
    map.addListener('click', function(e) {
      getClickLatLng(e.latLng, map);
    });
    function getClickLatLng(lat_lng, map) {
      // 座標の中心をずらす
      map.panTo(lat_lng);
    }
    for (var i = 0; i < mapped_image_position_size; i++) {
      click_Event(i,mapped_image_positions[i],map);
    }

    function click_Event(i,lat_lng, map) {
      $('.mapped_image_index_'+i).on('click', function() {
        console.log('click');
        marker.setMap(null);
        marker = new google.maps.Marker({
          map: map,
          position: lat_lng
        });
        infoWindow = new google.maps.InfoWindow({ // 吹き出しの追加
          content: "お待ちください"    // 吹き出しに表示する内容
        });
        markerEvent(mapped_image_id[i]);
        // 座標の中心をずらす
        map.panTo(lat_lng);
        $(".mapped_image_field").css('background-color','white');
        $(".mapped_image_field_"+i).css('background-color','lightgray');
      });
    }
    }

  //inputのvalueで検索して地図を表示
  return {
    getAddress: function() {
      // ボタンに指定したid要素を取得
      var button = document.getElementById("map_button");

      // ボタンが押された時の処理
      button.onclick = function() {
        var mapped_image_position_size = $(".mapped_image_position").length;
        var mapped_image_positions = new Array(mapped_image_position_size)
        for (var i = 0; i < mapped_image_position_size; i++) {
          // フォームに入力された住所情報を取得
          var lat_string = document.getElementById("mapped_image_position_lat_"+i).value;
          var lng_string = document.getElementById("mapped_image_position_lng_"+i).value;
          mapped_image_positions[i] = {
            lat: Number(lat_string), // 緯度
            lng: Number(lng_string) // 経度
          };
        }
        var address = document.getElementById("address").value;
        // 取得した住所を引数に指定してcodeAddress()関数を実行
        codeAddress(mapped_image_positions,address,mapped_image_position_size);
      }

      //読み込まれたときに地図を表示
      window.onload = function(){
        var mapped_image_position_size = $(".mapped_image_position").length;
        var mapped_image_positions = new Array(mapped_image_position_size)
        var mapped_image_id = new Array(mapped_image_position_size)
        for (var i = 0; i < mapped_image_position_size; i++) {
          // フォームに入力された住所情報を取得
          var id_string = document.getElementById("mapped_image_id_"+i).value;
          var lat_string = document.getElementById("mapped_image_position_lat_"+i).value;
          var lng_string = document.getElementById("mapped_image_position_lng_"+i).value;
          mapped_image_positions[i] = {
            lat: Number(lat_string), // 緯度
            lng: Number(lng_string) // 経度
          };
          mapped_image_id[i] = Number(id_string);
        }
        var address = document.getElementById("address").value;
        // 取得した住所を引数に指定してcodeAddress()関数を実行
        codeAddress(mapped_image_id,mapped_image_positions,address,mapped_image_position_size);
      }
    }
  };
})();

var GetMap = (function() {
  function codeAddress(mapped_image_id,mapped_image_positions,address,mapped_image_position_size) {
    // google.maps.Geocoder()コンストラクタのインスタンスを生成
    var geocoder = new google.maps.Geocoder();

    // 地図表示に関するオプション
    var mapOptions = {
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    // 地図を表示させるインスタンスを生成
    var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    //マーカー変数用意
    var marker = Array(mapped_image_positions.length);
    var infoWindow = Array(mapped_image_positions.length);
    var showing_mapped_image_id = Array(mapped_image_positions.length);

      for (var i = 0; i < mapped_image_position_size; i++) {

        // マーカー設定
        marker[i] = new google.maps.Marker({
          map: map,
          position: mapped_image_positions[i] //results[0].geometry.location = (lat,lng)
        });

        infoWindow[i] = new google.maps.InfoWindow({ // 吹き出しの追加
        content: "お待ちください"    // 吹き出しに表示する内容
        });


        markerEvent(i);

      }

    function markerEvent(i) {
      marker[i].addListener('click', function() { // マーカーをクリックしたとき

              $.ajax({
                url: "/lincoln_riders/mapped_images/get_window_content",
                type: "GET",
                data: { showing_mapped_image_id : mapped_image_id[i]
                        },
                dataType: "json",
                success: function(data) {
                  console.log("ajax成功");
                  infoWindow[i].setContent( '<div>'+data.text+'</div>'+
                                            '<img class="attachment mapped_image image" src="'+data.image_id+'">' ) ;
                  infoWindow[i].open(map, marker[i]); // 吹き出しの表示
                },
                error: function(){
                  console.log('ajax失敗');
                },
              })
      });
    }

    geocoder.geocode( { 'address': address}, function(results, status) {

      // ジオコーディングが成功した場合
      if (status == google.maps.GeocoderStatus.OK) {

        // 変換した緯度・経度情報を地図の中心に表示
        map.setCenter(results[0].geometry.location);

      // ジオコーディングが成功しなかった場合
      } else {
        console.log('Geocode was not successful for the following reason: ' + status);
      }

    });
    map.setCenter(mapped_image_positions[0]);

      // マップをクリックで位置変更
    map.addListener('click', function(e) {
      getClickLatLng(e.latLng, map);
    });
    function getClickLatLng(lat_lng, map) {

      // 座標の中心をずらす
      map.panTo(lat_lng);
    }

    }

  //inputのvalueで検索して地図を表示
  return {
    getAddress: function() {
      // ボタンに指定したid要素を取得
      var button = document.getElementById("map_button");

      // ボタンが押された時の処理
      button.onclick = function() {
        var mapped_image_position_size = $(".mapped_image_position").length;
        var mapped_image_positions = new Array(mapped_image_position_size)
        for (var i = 0; i < mapped_image_position_size; i++) {
          // フォームに入力された住所情報を取得
          var lat_string = document.getElementById("mapped_image_position_lat_"+i).value;
          var lng_string = document.getElementById("mapped_image_position_lng_"+i).value;
          mapped_image_positions[i] = {
            lat: Number(lat_string), // 緯度
            lng: Number(lng_string) // 経度
          };
        }
        var address = document.getElementById("address").value;
        // 取得した住所を引数に指定してcodeAddress()関数を実行
        codeAddress(mapped_image_positions,address,mapped_image_position_size);
      }

      //読み込まれたときに地図を表示
      window.onload = function(){
        var mapped_image_position_size = $(".mapped_image_position").length;
        var mapped_image_positions = new Array(mapped_image_position_size)
        var mapped_image_id = new Array(mapped_image_position_size)
        for (var i = 0; i < mapped_image_position_size; i++) {
          // フォームに入力された住所情報を取得
          var id_string = document.getElementById("mapped_image_id_"+i).value;
          var lat_string = document.getElementById("mapped_image_position_lat_"+i).value;
          var lng_string = document.getElementById("mapped_image_position_lng_"+i).value;
          mapped_image_positions[i] = {
            lat: Number(lat_string), // 緯度
            lng: Number(lng_string) // 経度
          };
          mapped_image_id[i] = Number(id_string);
        }
        var address = document.getElementById("address").value;
        // 取得した住所を引数に指定してcodeAddress()関数を実行
        codeAddress(mapped_image_id,mapped_image_positions,address,mapped_image_position_size);
      }
    }
  };
})();

var GetMapForNew = (function() {
	function ForNew(address) {
		var geocoder = new google.maps.Geocoder();
		var mapOptions = {
			zoom: 16,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		};
		var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
		var marker;
		geocoder.geocode( { 'address': address}, function(results, status) {

			// ジオコーディングが成功した場合
			if (status == google.maps.GeocoderStatus.OK) {
				map.setCenter(results[0].geometry.location);
				marker = new google.maps.Marker({
					map: map,
					position: results[0].geometry.location
				});
				document.getElementById("mapped_image_position_lat").value = results[0].geometry.location.lat();
				document.getElementById("mapped_image_position_lng").value = results[0].geometry.location.lng();
				console.log('Geocode was successful');
			// ジオコーディングが成功しなかった場合
			} else {
				console.log('Geocode was not successful for the following reason: ' + status);
			}
		});
		map.addListener('click', function(e) {
			getClickLatLng(e.latLng, map);

		});
		function getClickLatLng(lat_lng, map) {
			marker.setMap(null);
			marker = new google.maps.Marker({
				map: map,
				position: lat_lng
			});
			document.getElementById("mapped_image_position_lat").value = lat_lng.lat();
			document.getElementById("mapped_image_position_lng").value = lat_lng.lng();
			// 座標の中心をずらす
			map.panTo(lat_lng);
		}
	};
	return {
		CenterMaker: function() {
			// ボタンに指定したid要素を取得
			var button = document.getElementById("map_button");

			// ボタンが押された時の処理
			button.onclick = function() {
				var address = document.getElementById("address").value;
				// 取得した住所を引数に指定してcodeAddress()関数を実行
				ForNew(address);
			}

			//読み込まれたときに地図を表示
			window.onload = function(){
				var address = document.getElementById("address").value;
				// 取得した住所を引数に指定してcodeAddress()関数を実行
				ForNew(address);
			}
		}
	};
})();

