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
    $('.slick_field').slick({
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
        post_fav.innerHTML = '<a class="post_fav_deatroy" data-remote="true" rel="nofollow" data-method="delete" href="/lincoln_riders/posts/'+e.detail[0][0].post_id+'/post_favs"><i class="fa fa-heart" aria-hidden="true" style="color:red;"></i></a>'
    }
    if (e.detail[0][0].done == "destroy"){
        var post_fav = document.getElementById('post_fav')
        post_fav.innerHTML = '<a class="post_fav_create" data-remote="true" rel="nofollow" data-method="post" href="/lincoln_riders/posts/'+e.detail[0][0].post_id+'/post_favs"><i class="fa fa-heart" aria-hidden="true"></i></a>'
    }
  });

    $(document).on('ajax:success', '#mapped_images_fav a', function(e) {
    console.log(e.detail[0][0]);
    if (e.detail[0][0].done == "save"){
        var mapped_images_fav = document.getElementById('mapped_images_fav')
        mapped_images_fav.innerHTML = '<a class="mapped_images_fav_deatroy" data-remote="true" rel="nofollow" data-method="delete" href="/lincoln_riders/mapped_images/'+e.detail[0][0].mapped_image_id+'/mapped_images_favs"><i class="fa fa-heart" aria-hidden="true" style="color:red;"></i></a>'
    }
    if (e.detail[0][0].done == "destroy"){
        var mapped_images_fav = document.getElementById('mapped_images_fav')
        mapped_images_fav.innerHTML = '<a class="mapped_images_fav_create" data-remote="true" rel="nofollow" data-method="post" href="/lincoln_riders/mapped_images/'+e.detail[0][0].mapped_image_id+'/mapped_images_favs"><i class="fa fa-heart" aria-hidden="true"></i></a>'
    }
  });

});


var SetMap = (function() {
  var markers = new Array()
    function GetPresentLocation() {
      return new Promise((resolve, reject) => {
        var lat_lng
        function success(position) {
          var lat_lng = {
              lat: position.coords.latitude, // 緯度
              lng: position.coords.longitude // 経度
          };
          console.log("座標位置を取得できました")
          resolve(lat_lng)
        };
        function error() {
          console.log("座標位置を取得できません")
          reject()
        };
        navigator.geolocation.getCurrentPosition(success, error);
      });
    }
    // 地図の初期設定
    function InitMap(map_canvas,mapped_image_position_lat,mapped_image_position_lng){ //map_canvas = id name of div showing map
      return new Promise((resolve, reject) => {
        GetPositionFrom(mapped_image_position_lat, mapped_image_position_lng).then(function(lat_lng){
        console.log(lat_lng)
        var mapOptions = {
          center: lat_lng,
          zoom: 16,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById(map_canvas), mapOptions);

        resolve(map)
      });
    });



    };

    // ビューから緯度、経度を取得する
    function GetPositionFrom(mapped_image_position_lat,mapped_image_position_lng){
      return new Promise((resolve, reject) => {
          if ((document.getElementById(mapped_image_position_lat)!=null) && (document.getElementById(mapped_image_position_lng)!=null)){
            var lat_string = document.getElementById(mapped_image_position_lat).value;
            var lng_string = document.getElementById(mapped_image_position_lng).value;
              if (lat_string == "" || lng_string == ""){
                console.log("位置情報が空欄です")
                GetPresentLocation().then(function(position){
                  var lat_lng = {
                    lat: position.lat, // 緯度
                    lng: position.lng // 経度
                  };
                  document.getElementById("mapped_image_position_lat").value = lat_lng.lat;
                  document.getElementById("mapped_image_position_lng").value = lat_lng.lng;
                  resolve(lat_lng)
                }).catch(function(){
                  var lat_lng = {
                    lat: 0, // 緯度
                    lng: 0 // 経度
                  };
                  document.getElementById("mapped_image_position_lat").value = lat_lng.lat;
                  document.getElementById("mapped_image_position_lng").value = lat_lng.lng;
                  resolve(lat_lng)
                });
              } else{
                var lat_lng = {
                  lat: Number(lat_string), // 緯度
                  lng: Number(lng_string) // 経度
                };
                resolve(lat_lng)
              }
          }
        });
    };

    // 検索機能
    function GetAddress(map) {
      return new Promise((resolve, reject) => {
        var lat_lng
        var address = document.getElementById("address").value;
          // 取得した住所を引数に指定してcodeAddress()関数を実行
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode( { 'address': address}, function(results, status) {
        // ジオコーディングが成功した場合
        if (status == google.maps.GeocoderStatus.OK) {
          if ((document.getElementById("mapped_image_position_lat")!=null) && (document.getElementById("mapped_image_position_lng")!=null)){
            document.getElementById("mapped_image_position_lat").value = results[0].geometry.location.lat();
            document.getElementById("mapped_image_position_lng").value = results[0].geometry.location.lng();
          }
          console.log('Geocode was successful');
          lat_lng = results[0].geometry.location
          resolve(lat_lng)
        // ジオコーディングが成功しなかった場合
        } else {
          console.log('Geocode was not successful for the following reason: ' + status);
          reject()
        }
        });
      });
    }


    // マップ上をクリックした時の処理
    function getClickLatLng(lat_lng) {
      document.getElementById("mapped_image_position_lat").value = lat_lng.lat();
      document.getElementById("mapped_image_position_lng").value = lat_lng.lng();
    }


    // マーカーを移動させる
    function MoveMarker(map){
        var lat_lng = GetPositionFrom("mapped_image_position_lat","mapped_image_position_lng").then(function(lat_lng){

          markers.forEach(function(marker){
            if (marker == null){  //markerがなければ無視する

            }else{  //markerがあれば残っているmarkerを隠す
              marker.setMap(null);
            }
          });
          var marker = new google.maps.Marker({
            map: map,
            position: lat_lng
          });

          markers.push(marker);
          // 座標の中心をずらす
          map.panTo(lat_lng);
          console.log("marker")
          console.log(marker)
          return{
            marker
          }
        });
    };


    // マーカーを設置する
    function SetMarkers(map){
      var mapped_image_position_size = $(".mapped_image_position").length;
      var mapped_image_positions = Array();
      var mapped_image_positions_id = Array();
      var infoWindows = Array();
      var j = 0;
      for (var i = 0; i < mapped_image_position_size; i++) {
        GetPositionFrom("mapped_image_position_lat_"+i,"mapped_image_position_lng_"+i).then(function(mapped_image_position){
          var mapped_image_position_id = GetIdFrom("mapped_image_id_"+j);
          mapped_image_positions_id.push(mapped_image_position_id);
          var marker = new google.maps.Marker({
            map: map,
            position: mapped_image_position //results[0].geometry.location = (lat,lng)
          });
          markers.push(marker);
          infoWindow = new google.maps.InfoWindow({ // 吹き出しの追加
            content: "お待ちください"    // 吹き出しに表示する内容
          });
          infoWindows.push(infoWindow)
          MarkerClickEvent(marker,mapped_image_position_id.id,infoWindow,map)
          ImageClickEvent(j,mapped_image_position, map)
          j ++;
        });
      }

    };

    // ビューからidを取得する
    function GetIdFrom(mapped_image_id){
      var id
      var id_string = document.getElementById(mapped_image_id).value;
      if (id_string == ""){
        console.log("mapped_image_idのidが空欄です")
      } else{
        id = Number(id_string)
      }
      return{
        id
      }
    };

    // 画像をクリックした時の処理
    function ImageClickEvent(i,lat_lng, map) {
      $('.mapped_image_index_'+i).on('click', function() {
        console.log('click');
        // 座標の中心をずらす
        map.panTo(lat_lng);
        $(".mapped_image_field").css('background-color','white');
        $(".mapped_image_field_"+i).css('background-color','lightgray');
      });
    }

    // マーカーをクリックした時の処理
    function MarkerClickEvent(marker,mapped_image_id,infoWindow,map) {
      marker.addListener('click', function() { // マーカーをクリックしたとき

              $.ajax({
                url: "/lincoln_riders/mapped_images/get_window_content",
                type: "GET",
                data: { showing_mapped_image_id : mapped_image_id
                        },
                dataType: "json",
                success: function(data) {
                  console.log("ajax成功");
                  infoWindow.setContent( '<div class="infowindow">'+
                                            '<div class="mapped_image_text">'+
                                              '<div class="infowindow_title">content<br></div>'+
                                              data.text+
                                            '</div>'+
                                            '<img class="attachment mapped_image image " src="'+data.image_id+'">'+
                                          '</div>') ;
                  infoWindow.open(map, marker); // 吹き出しの表示
                },
                error: function(){
                  console.log('ajax失敗');
                },
              })
      });
    }

    return {


      ForCreateUpdate: function() {
        var button = document.getElementById("map_button");
        var map = InitMap("map-canvas","mapped_image_position_lat","mapped_image_position_lng").then(function(map){
          MoveMarker(map)

          // ボタンが押された時の処理
          $(document).on('click', '#map_button', function() {
             GetAddress(map).then(function(lat_lng){
               MoveMarker(map)
             });
          });
          map.addListener('click', function(e) {
            getClickLatLng(e.latLng);
            MoveMarker(map);
          });
          $('#mapped_image_position_lat').change(function() {
            marker = MoveMarker(map);
          });
          $('#mapped_image_position_lng').change(function() {
            marker = MoveMarker(map);
          });
        });

      },


      ForRead: function() {
        var button = document.getElementById("map_button");
        var map = InitMap("map-canvas","mapped_image_position_lat_0","mapped_image_position_lng_0").then(function(map){
          SetMarkers(map)
          // ボタンが押された時の処理
          $(document).on('click', '#map_button', function() {
            var lat_lng = GetAddress(map).then(function(lat_lng){
              map.panTo(lat_lng);
            });
          });
        });
      }


    };
  })();

$(function() {

  function MenuBarOpen(){
    $(".menu_bar").css({
        "display": "block",
    });
    $("#menu_icon_open").css({
        "display": "none",
    });
    $("#menu_icon_close").css({
        "display": "block",
    });
  };
  function MenuBarClose(){
    $(".menu_bar").css({
        "display": "none",
    });
    $("#menu_icon_open").css({
        "display": "block",
    });
    $("#menu_icon_close").css({
        "display": "none",
    });
  };

  $(document).on('mouseover', '#menu_icon_open', function() {
    MenuBarOpen();
  });
  $(document).on('mouseover', '.menu_bar', function() {
    MenuBarOpen();
  });

  $(document).on('mouseout', '.menu_bar', function() {
    MenuBarClose();
  });

});

