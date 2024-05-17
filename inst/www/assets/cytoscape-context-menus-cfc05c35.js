import{g as bt}from"./core-js-bbf708ea.js";var mt={exports:{}};(function(dt,xt){(function(ot,G){dt.exports=G()})(self,function(){return(()=>{var ot={621:(C,S,I)=>{function X(o,i){(i==null||i>o.length)&&(i=o.length);for(var e=0,t=new Array(i);e<i;e++)t[e]=o[e];return t}function W(o){for(var i="",e=0;e<o.length;e++)i+=o[e],e!==o.length-1&&(i+=" ");return i}function B(o,i,e){e?o.setAttribute(i,""):o.removeAttribute(i)}function K(o,i,e){customElements.get(o)===void 0&&customElements.define(o,i,{extends:e})}I.r(S),I.d(S,{contextMenus:()=>pt});var P="cy-context-menus-divider",vt={evtType:"cxttap",menuItems:[],menuItemClasses:["cy-context-menus-cxt-menuitem"],contextMenuClasses:["cy-context-menus-cxt-menu"],submenuIndicator:{src:"assets/submenu-indicator-default.svg",width:12,height:12}};function ut(o){return(ut=typeof Symbol=="function"&&typeof Symbol.iterator=="symbol"?function(i){return typeof i}:function(i){return i&&typeof Symbol=="function"&&i.constructor===Symbol&&i!==Symbol.prototype?"symbol":typeof i})(o)}function Y(o,i){var e;if(typeof Symbol>"u"||o[Symbol.iterator]==null){if(Array.isArray(o)||(e=function(f,E){if(f){if(typeof f=="string")return st(f,E);var m=Object.prototype.toString.call(f).slice(8,-1);return m==="Object"&&f.constructor&&(m=f.constructor.name),m==="Map"||m==="Set"?Array.from(f):m==="Arguments"||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(m)?st(f,E):void 0}}(o))||i&&o&&typeof o.length=="number"){e&&(o=e);var t=0,n=function(){};return{s:n,n:function(){return t>=o.length?{done:!0}:{done:!1,value:o[t++]}},e:function(f){throw f},f:n}}throw new TypeError(`Invalid attempt to iterate non-iterable instance.
In order to be iterable, non-array objects must have a [Symbol.iterator]() method.`)}var r,a=!0,u=!1;return{s:function(){e=o[Symbol.iterator]()},n:function(){var f=e.next();return a=f.done,f},e:function(f){u=!0,r=f},f:function(){try{a||e.return==null||e.return()}finally{if(u)throw r}}}}function st(o,i){(i==null||i>o.length)&&(i=o.length);for(var e=0,t=new Array(i);e<i;e++)t[e]=o[e];return t}function Q(o,i){if(!(o instanceof i))throw new TypeError("Cannot call a class as a function")}function at(o,i){for(var e=0;e<i.length;e++){var t=i[e];t.enumerable=t.enumerable||!1,t.configurable=!0,"value"in t&&(t.writable=!0),Object.defineProperty(o,t.key,t)}}function Z(o,i,e){return i&&at(o.prototype,i),e&&at(o,e),o}function tt(o,i){if(typeof i!="function"&&i!==null)throw new TypeError("Super expression must either be null or a function");o.prototype=Object.create(i&&i.prototype,{constructor:{value:o,writable:!0,configurable:!0}}),i&&q(o,i)}function et(o){var i=lt();return function(){var e,t=g(o);if(i){var n=g(this).constructor;e=Reflect.construct(t,arguments,n)}else e=t.apply(this,arguments);return yt(this,e)}}function yt(o,i){return!i||ut(i)!=="object"&&typeof i!="function"?A(o):i}function A(o){if(o===void 0)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return o}function k(o,i,e){return(k=typeof Reflect<"u"&&Reflect.get?Reflect.get:function(t,n,r){var a=function(f,E){for(;!Object.prototype.hasOwnProperty.call(f,E)&&(f=g(f))!==null;);return f}(t,n);if(a){var u=Object.getOwnPropertyDescriptor(a,n);return u.get?u.get.call(r):u.value}})(o,i,e||o)}function nt(o){var i=typeof Map=="function"?new Map:void 0;return(nt=function(e){if(e===null||(t=e,Function.toString.call(t).indexOf("[native code]")===-1))return e;var t;if(typeof e!="function")throw new TypeError("Super expression must either be null or a function");if(i!==void 0){if(i.has(e))return i.get(e);i.set(e,n)}function n(){return ct(e,arguments,g(this).constructor)}return n.prototype=Object.create(e.prototype,{constructor:{value:n,enumerable:!1,writable:!0,configurable:!0}}),q(n,e)})(o)}function ct(o,i,e){return(ct=lt()?Reflect.construct:function(t,n,r){var a=[null];a.push.apply(a,n);var u=new(Function.bind.apply(t,a));return r&&q(u,r.prototype),u}).apply(null,arguments)}function lt(){if(typeof Reflect>"u"||!Reflect.construct||Reflect.construct.sham)return!1;if(typeof Proxy=="function")return!0;try{return Date.prototype.toString.call(Reflect.construct(Date,[],function(){})),!0}catch{return!1}}function q(o,i){return(q=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(o,i)}function g(o){return(g=Object.setPrototypeOf?Object.getPrototypeOf:function(i){return i.__proto__||Object.getPrototypeOf(i)})(o)}function V(o){o.preventDefault(),o.stopPropagation()}var _=function(o){tt(e,o);var i=et(e);function e(t,n,r){var a,u,f,E,m,O,w,N,$,v;Q(this,e),k((u=A(v=i.call(this)),g(e.prototype)),"setAttribute",u).call(u,"id",t.id);var l=v._getMenuItemClassStr(r.cxtMenuItemClasses,t.hasTrailingDivider);if(k((f=A(v),g(e.prototype)),"setAttribute",f).call(f,"class",l),k((E=A(v),g(e.prototype)),"setAttribute",E).call(E,"title",(a=t.tooltipText)!==null&&a!==void 0?a:""),t.disabled&&B(A(v),"disabled",!0),t.image){var s=document.createElement("img");s.src=t.image.src,s.width=t.image.width,s.height=t.image.height,s.style.position="absolute",s.style.top=t.image.y+"px",s.style.left=t.image.x+"px",k((m=A(v),g(e.prototype)),"appendChild",m).call(m,s)}if(v.innerHTML+=t.content,v.onMenuItemClick=n,v.data={},v.clickFns=[],v.selector=t.selector,v.hasTrailingDivider=t.hasTrailingDivider,v.show=t.show===void 0||t.show,v.coreAsWell=t.coreAsWell||!1,v.scratchpad=r,t.onClickFunction===void 0&&t.submenu===void 0)throw new Error("A menu item must either have click function or a submenu or both");return v.onClickFunction=t.onClickFunction,t.submenu instanceof Array&&v._createSubmenu(t.submenu),k((O=A(v),g(e.prototype)),"addEventListener",O).call(O,"mousedown",V),k((w=A(v),g(e.prototype)),"addEventListener",w).call(w,"mouseup",V),k((N=A(v),g(e.prototype)),"addEventListener",N).call(N,"touchstart",V),k(($=A(v),g(e.prototype)),"addEventListener",$).call($,"touchend",V),v}return Z(e,[{key:"bindOnClickFunction",value:function(t){this.clickFns.push(t),k(g(e.prototype),"addEventListener",this).call(this,"click",t)}},{key:"unbindOnClickFunctions",value:function(){var t,n=Y(this.clickFns);try{for(n.s();!(t=n.n()).done;){var r=t.value;k(g(e.prototype),"removeEventListener",this).call(this,"click",r)}}catch(a){n.e(a)}finally{n.f()}this.clickFns=[]}},{key:"enable",value:function(){B(this,"disabled",!1),this.hasSubmenu()&&this.addEventListener("mouseenter",this.mouseEnterHandler)}},{key:"disable",value:function(){B(this,"disabled",!0),this.hasSubmenu()&&this.removeEventListener("mouseenter",this.mouseEnterHandler)}},{key:"hide",value:function(){this.show=!1,this.style.display="none"}},{key:"getHasTrailingDivider",value:function(){return!!this.hasTrailingDivider}},{key:"setHasTrailingDivider",value:function(t){this.hasTrailingDivider=t}},{key:"hasSubmenu",value:function(){return this.submenu instanceof F}},{key:"appendSubmenuItem",value:function(t){var n=arguments.length>1&&arguments[1]!==void 0?arguments[1]:void 0;this.hasSubmenu()||this._createSubmenu(),this.submenu.appendMenuItem(t,n)}},{key:"isClickable",value:function(){return this.onClickFunction!==void 0}},{key:"display",value:function(){this.show=!0,this.style.display="block"}},{key:"isVisible",value:function(){return this.show===!0&&this.style.display!=="none"}},{key:"removeSubmenu",value:function(){this.hasSubmenu()&&(this.submenu.removeAllMenuItems(),this.detachSubmenu())}},{key:"detachSubmenu",value:function(){this.hasSubmenu()&&(this.removeChild(this.submenu),this.removeChild(this.indicator),this.removeEventListener("mouseenter",this.mouseEnterHandler),this.removeEventListener("mouseleave",this.mouseLeaveHandler),this.submenu=void 0,this.indicator=void 0)}},{key:"_onMouseEnter",value:function(t){var n=this.getBoundingClientRect(),r=function(m){m.style.opacity="0",m.style.display="block";var O=m.getBoundingClientRect();return m.style.opacity="1",m.style.display="none",O}(this.submenu),a=n.right+r.width>window.innerWidth,u=n.top+r.height>window.innerHeight;a||u?a&&!u?(this.submenu.style.right=this.clientWidth+"px",this.submenu.style.top="0px",this.submenu.style.left="auto",this.submenu.style.bottom="auto"):a&&u?(this.submenu.style.right=this.clientWidth+"px",this.submenu.style.bottom="0px",this.submenu.style.top="auto",this.submenu.style.left="auto"):(this.submenu.style.left=this.clientWidth+"px",this.submenu.style.bottom="0px",this.submenu.style.right="auto",this.submenu.style.top="auto"):(this.submenu.style.left=this.clientWidth+"px",this.submenu.style.top="0px",this.submenu.style.right="auto",this.submenu.style.bottom="auto"),this.submenu.display();var f=Array.from(this.submenu.children).filter(function(m){if(m instanceof e)return m.isVisible()}),E=f.length;f.forEach(function(m,O){m instanceof e&&(O<E-1&&m.getHasTrailingDivider()?m.classList.add(P):m.getHasTrailingDivider()&&m.classList.remove(P))})}},{key:"_onMouseLeave",value:function(t){var n,r,a,u,f;n={x:t.clientX,y:t.clientY},r=this.submenu,u=n.y,(a=n.x)>=(f=r.getBoundingClientRect()).left&&a<=f.right&&u>=f.top&&u<=f.bottom||this.submenu.hide()}},{key:"_createSubmenu",value:function(){var t=arguments.length>0&&arguments[0]!==void 0?arguments[0]:[];this.indicator=this.scratchpad.submenuIndicatorGen(),this.submenu=new F(this.onMenuItemClick,this.scratchpad),this.appendChild(this.indicator),this.appendChild(this.submenu);var n,r=Y(t);try{for(r.s();!(n=r.n()).done;){var a=n.value,u=new e(a,this.onMenuItemClick,this.scratchpad);this.submenu.appendMenuItem(u)}}catch(f){r.e(f)}finally{r.f()}this.mouseEnterHandler=this._onMouseEnter.bind(this),this.mouseLeaveHandler=this._onMouseLeave.bind(this),this.addEventListener("mouseenter",this.mouseEnterHandler),this.addEventListener("mouseleave",this.mouseLeaveHandler)}},{key:"_getMenuItemClassStr",value:function(t,n){return n?t+" "+P:t}}],[{key:"define",value:function(){K("ctx-menu-item",e,"button")}}]),e}(nt(HTMLButtonElement)),F=function(o){tt(e,o);var i=et(e);function e(t,n){var r,a;return Q(this,e),k((r=A(a=i.call(this)),g(e.prototype)),"setAttribute",r).call(r,"class",n.cxtMenuClasses),a.style.position="absolute",a.onMenuItemClick=t,a.scratchpad=n,a}return Z(e,[{key:"hide",value:function(){this.isVisible()&&(this.hideSubmenus(),this.style.display="none")}},{key:"display",value:function(){this.style.display="block"}},{key:"isVisible",value:function(){return this.style.display!=="none"}},{key:"hideMenuItems",value:function(){var t,n=Y(this.children);try{for(n.s();!(t=n.n()).done;){var r=t.value;r instanceof HTMLElement?r.style.display="none":console.warn("".concat(r," is not a HTMLElement"))}}catch(a){n.e(a)}finally{n.f()}}},{key:"hideSubmenus",value:function(){var t,n=Y(this.children);try{for(n.s();!(t=n.n()).done;){var r=t.value;r instanceof _&&r.submenu&&r.submenu.hide()}}catch(a){n.e(a)}finally{n.f()}}},{key:"appendMenuItem",value:function(t){var n=arguments.length>1&&arguments[1]!==void 0?arguments[1]:void 0;if(n!==void 0){if(n.parentNode!==this)throw new Error("The item with id='".concat(n.id,"' is not a child of the context menu"));this.insertBefore(t,n)}else this.appendChild(t);t.isClickable()&&this._performBindings(t)}},{key:"moveBefore",value:function(t,n){if(t.parentNode!==this)throw new Error("The item with id='".concat(t.id,"' is not a child of context menu"));if(n.parentNode!==this)throw new Error("The item with id='".concat(n.id,"' is not a child of context menu"));this.removeChild(t),this.insertBefore(t,n)}},{key:"removeAllMenuItems",value:function(){for(;this.firstChild;){var t=this.lastChild;t instanceof _?this._removeImmediateMenuItem(t):(console.warn("Found non menu item in the context menu: ",t),this.removeChild(t))}}},{key:"_removeImmediateMenuItem",value:function(t){if(!this._detachImmediateMenuItem(t))throw new Error("menu item(id=".concat(t.id,") is not in the context menu"));t.detachSubmenu(),t.unbindOnClickFunctions()}},{key:"_detachImmediateMenuItem",value:function(t){if(t.parentNode===this){if(this.removeChild(t),this.children.length<=0){var n=this.parentNode;n instanceof _&&n.detachSubmenu()}return!0}return!1}},{key:"_performBindings",value:function(t){var n=this._bindOnClick(t.onClickFunction);t.bindOnClickFunction(n),t.bindOnClickFunction(this.onMenuItemClick)}},{key:"_bindOnClick",value:function(t){var n=this;return function(){var r=n.scratchpad.currentCyEvent;t(r)}}}],[{key:"define",value:function(){K("menu-item-list",e,"div")}}]),e}(nt(HTMLDivElement)),ft=function(o){tt(e,o);var i=et(e);function e(t,n){var r;return Q(this,e),(r=i.call(this,t,n)).onMenuItemClick=function(a){V(a),r.hide(),t()},r}return Z(e,[{key:"removeMenuItem",value:function(t){var n=t.parentElement;n instanceof F&&this.contains(n)&&n._removeImmediateMenuItem(t)}},{key:"appendMenuItem",value:function(t){var n=arguments.length>1&&arguments[1]!==void 0?arguments[1]:void 0;this.ensureDoesntContain(t.id),k(g(e.prototype),"appendMenuItem",this).call(this,t,n)}},{key:"insertMenuItem",value:function(t){var n=arguments.length>1&&arguments[1]!==void 0?arguments[1]:{},r=n.before,a=n.parent;if(this.ensureDoesntContain(t.id),r!==void 0){if(!this.contains(r))throw new Error("before(id=".concat(r.id,") is not in the context menu"));var u=r.parentNode;if(!(u instanceof F))throw new Error("Parent of before(id=".concat(r.id,") is not a submenu"));u.appendMenuItem(t,r)}else if(a!==void 0){if(!this.contains(a))throw new Error("parent(id=".concat(a.id,") is not a descendant of the context menu"));a.appendSubmenuItem(t)}else this.appendMenuItem(t)}},{key:"moveBefore",value:function(t,n){var r=t.parentElement;if(!this.contains(r))throw new Error("parent(id=".concat(r.id,") is not in the contex menu"));if(!this.contains(n))throw new Error("before(id=".concat(n.id,") is not in the context menu"));r.removeChild(t),this.insertMenuItem(t,{before:n})}},{key:"moveToSubmenu",value:function(t){var n=arguments.length>1&&arguments[1]!==void 0?arguments[1]:null,r=arguments.length>2&&arguments[2]!==void 0?arguments[2]:null,a=t.parentElement;if(!(a instanceof F))throw new Error("current parent(id=".concat(a.id,") is not a submenu"));if(!this.contains(a))throw new Error("parent of the menu item(id=".concat(a.id,") is not in the context menu"));if(n!==null){if(!this.contains(n))throw new Error("parent(id=".concat(n.id,") is not in the context menu"));a._detachImmediateMenuItem(t),n.appendSubmenuItem(t)}else r!==null&&(t.selector=r.selector,t.coreAsWell=r.coreAsWell),a._detachImmediateMenuItem(t),this.appendMenuItem(t)}},{key:"ensureDoesntContain",value:function(t){var n=document.getElementById(t);if(n!==void 0&&this.contains(n))throw new Error("There is already an element with id=".concat(t," in the context menu"))}}],[{key:"define",value:function(){K("ctx-menu",e,"div")}}]),e}(F);function ht(o,i){(i==null||i>o.length)&&(i=o.length);for(var e=0,t=new Array(i);e<i;e++)t[e]=o[e];return t}function pt(o){var i=this;i.scratch("cycontextmenus")||i.scratch("cycontextmenus",{});var e,t,n=function(l){return i.scratch("cycontextmenus")[l]},r=function(l,s){return i.scratch("cycontextmenus")[l]=s},a=n("options"),u=n("cxtMenu"),f=function(l){var s=arguments.length>1&&arguments[1]!==void 0?arguments[1]:void 0,c=m(l);if(s!==void 0){var y=w(s);u.insertMenuItem(c,{parent:y})}else u.insertMenuItem(c)},E=function(l){for(var s=arguments.length>1&&arguments[1]!==void 0?arguments[1]:void 0,c=0;c<l.length;c++)f(l[c],s)},m=function(l){var s=i.scratch("cycontextmenus");return new _(l,u.onMenuItemClick,s)},O=function(){n("active")&&(u.removeAllMenuItems(),i.off("tapstart",n("eventCyTapStart")),i.off(a.evtType,n("onCxttap")),i.off("viewport",n("onViewport")),document.removeEventListener("mouseup",n("hideOnNonCyClick")),u.parentNode.removeChild(u),u=void 0,r("cxtMenu",void 0),r("active",!1),r("anyVisibleChild",!1),r("onCxttap",void 0),r("onViewport",void 0),r("hideOnNonCyClick",void 0))},w=function(l){var s=document.getElementById(l);if(s instanceof _)return s;throw new Error("The item with id=".concat(l," is not a menu item"))};if(o!=="get"){_.define(),F.define(),ft.define(),a=function(l,s){var c={};for(var y in l)c[y]=l[y];for(var d in s)c[d]instanceof Array?c[d]=c[d].concat(s[d]):c[d]=s[d];return c}(vt,o),r("options",a),n("active")&&O(),r("active",!0),r("submenuIndicatorGen",(function(l){var s=document.createElement("img");return s.src=l.src,s.width=l.width,s.height=l.height,s.classList.add("cy-context-menus-submenu-indicator"),s}).bind(void 0,a.submenuIndicator));var N=W(a.contextMenuClasses);r("cxtMenuClasses",N);var $=i.scratch("cycontextmenus");u=new ft(function(){return r("cxtMenuPosition",void 0)},$),r("cxtMenu",u),i.container().appendChild(u),r("cxtMenuItemClasses",W(a.menuItemClasses));var v=a.menuItems;E(v),t=function(l){r("currentCyEvent",l),function(h){var j,M=i.container(),p=n("cxtMenuPosition"),D=h.position||h.cyPosition;if(p!=D){u.hideMenuItems(),r("anyVisibleChild",!1),r("cxtMenuPosition",D);var T={top:(j=M.getBoundingClientRect()).top,left:j.left},x=h.renderedPosition||h.cyRenderedPosition,J=getComputedStyle(M)["border-width"],b=parseInt(J.replace("px",""))||0;b>0&&(T.top+=b,T.left+=b);var R=M.clientHeight,L=M.clientWidth,it=R/2,rt=L/2;x.y>it&&x.x<=rt?(u.style.left=x.x+"px",u.style.bottom=R-x.y+"px",u.style.right="auto",u.style.top="auto"):x.y>it&&x.x>rt?(u.style.right=L-x.x+"px",u.style.bottom=R-x.y+"px",u.style.left="auto",u.style.top="auto"):x.y<=it&&x.x<=rt?(u.style.left=x.x+"px",u.style.top=x.y+"px",u.style.right="auto",u.style.bottom="auto"):(u.style.right=L-x.x+"px",u.style.top=x.y+"px",u.style.left="auto",u.style.bottom="auto")}}(l);var s,c=l.target||l.cyTarget,y=function(h,j){var M;if(typeof Symbol>"u"||h[Symbol.iterator]==null){if(Array.isArray(h)||(M=function(b,R){if(b){if(typeof b=="string")return ht(b,R);var L=Object.prototype.toString.call(b).slice(8,-1);return L==="Object"&&b.constructor&&(L=b.constructor.name),L==="Map"||L==="Set"?Array.from(b):L==="Arguments"||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(L)?ht(b,R):void 0}}(h))||j&&h&&typeof h.length=="number"){M&&(h=M);var p=0,D=function(){};return{s:D,n:function(){return p>=h.length?{done:!0}:{done:!1,value:h[p++]}},e:function(b){throw b},f:D}}throw new TypeError(`Invalid attempt to iterate non-iterable instance.
In order to be iterable, non-array objects must have a [Symbol.iterator]() method.`)}var T,x=!0,J=!1;return{s:function(){M=h[Symbol.iterator]()},n:function(){var b=M.next();return x=b.done,b},e:function(b){J=!0,T=b},f:function(){try{x||M.return==null||M.return()}finally{if(J)throw T}}}}(u.children);try{for(y.s();!(s=y.n()).done;){var d=s.value;d instanceof _&&(c===i?d.coreAsWell:c.is(d.selector))&&d.show&&(u.display(),r("anyVisibleChild",!0),d.display())}}catch(h){y.e(h)}finally{y.f()}var U=Array.from(u.children).filter(function(h){if(h instanceof _)return h.isVisible()}),z=U.length;U.forEach(function(h,j){h instanceof _&&(j<z-1&&h.getHasTrailingDivider()?h.classList.add(P):h.getHasTrailingDivider()&&h.classList.remove(P))}),!n("anyVisibleChild")&&!function(h){return h.offsetWidth<=0&&h.offsetHeight<=0||h.style&&h.style.display||getComputedStyle(h).display}(u)&&u.hide()},i.on(a.evtType,t),r("onCxttap",t),function(){var l=function(c){if(u.contains(c.originalEvent.target))return!1;u.hide(),r("cxtMenuPosition",void 0),r("currentCyEvent",void 0)};i.on("tapstart",l),r("eventCyTapStart",l);var s=function(){u.hide()};i.on("viewport",s),r("onViewport",s)}(),e=function(l){i.container().contains(l.target)||u.contains(l.target)||(u.hide(),r("cxtMenuPosition",void 0))},document.addEventListener("mouseup",e),r("hideOnNonCyClick",e),function(){var l,s=function(c,y){var d;if(typeof Symbol>"u"||c[Symbol.iterator]==null){if(Array.isArray(c)||(d=function(p,D){if(p){if(typeof p=="string")return X(p,D);var T=Object.prototype.toString.call(p).slice(8,-1);return T==="Object"&&p.constructor&&(T=p.constructor.name),T==="Map"||T==="Set"?Array.from(p):T==="Arguments"||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(T)?X(p,D):void 0}}(c))||y&&c&&typeof c.length=="number"){d&&(c=d);var U=0,z=function(){};return{s:z,n:function(){return U>=c.length?{done:!0}:{done:!1,value:c[U++]}},e:function(p){throw p},f:z}}throw new TypeError(`Invalid attempt to iterate non-iterable instance.
In order to be iterable, non-array objects must have a [Symbol.iterator]() method.`)}var h,j=!0,M=!1;return{s:function(){d=c[Symbol.iterator]()},n:function(){var p=d.next();return j=p.done,p},e:function(p){M=!0,h=p},f:function(){try{j||d.return==null||d.return()}finally{if(M)throw h}}}}(document.getElementsByClassName("cy-context-menus-cxt-menu"));try{for(s.s();!(l=s.n()).done;)l.value.addEventListener("contextmenu",function(c){return c.preventDefault()})}catch(c){s.e(c)}finally{s.f()}}()}return function(l){return{isActive:function(){return n("active")},appendMenuItem:function(s){var c=arguments.length>1&&arguments[1]!==void 0?arguments[1]:void 0;return f(s,c),l},appendMenuItems:function(s){var c=arguments.length>1&&arguments[1]!==void 0?arguments[1]:void 0;return E(s,c),l},removeMenuItem:function(s){var c=w(s);return u.removeMenuItem(c),l},setTrailingDivider:function(s,c){var y=w(s);return y.setHasTrailingDivider(c),c?y.classList.add(P):y.classList.remove(P),l},insertBeforeMenuItem:function(s,c){var y=m(s),d=w(c);return u.insertMenuItem(y,{before:d}),l},moveToSubmenu:function(s){var c=arguments.length>1&&arguments[1]!==void 0?arguments[1]:null,y=w(s);if(c===null)u.moveToSubmenu(y);else if(typeof c=="string"){var d=w(c.toString());u.moveToSubmenu(y,d)}else c.coreAsWell!==void 0||c.selector!==void 0?u.moveToSubmenu(y,null,c):console.warn("options neither has coreAsWell nor selector property but it is an object. Are you sure that this is what you want to do?");return l},moveBeforeOtherMenuItem:function(s,c){var y=w(s),d=w(c);return u.moveBefore(y,d),l},disableMenuItem:function(s){return w(s).disable(),l},enableMenuItem:function(s){return w(s).enable(),l},hideMenuItem:function(s){return w(s).hide(),l},showMenuItem:function(s){return w(s).display(),l},destroy:function(){return O(),l}}}(this)}},579:(C,S,I)=>{var X=I(621).contextMenus,W=function(B){B&&B("core","contextMenus",X)};typeof cytoscape<"u"&&W(cytoscape),C.exports=W}},G={};function H(C){var S=G[C];if(S!==void 0)return S.exports;var I=G[C]={exports:{}};return ot[C](I,I.exports,H),I.exports}return H.d=(C,S)=>{for(var I in S)H.o(S,I)&&!H.o(C,I)&&Object.defineProperty(C,I,{enumerable:!0,get:S[I]})},H.o=(C,S)=>Object.prototype.hasOwnProperty.call(C,S),H.r=C=>{typeof Symbol<"u"&&Symbol.toStringTag&&Object.defineProperty(C,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(C,"__esModule",{value:!0})},H(579)})()})})(mt);var gt=mt.exports;const Mt=bt(gt);export{Mt as c};