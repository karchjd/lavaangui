function d(){}function F(t,n){for(const e in n)t[e]=n[e];return t}function L(t){return t()}function z(){return Object.create(null)}function x(t){t.forEach(L)}function N(t){return typeof t=="function"}function D(t,n){return t!=t?n==n:t!==n||t&&typeof t=="object"||typeof t=="function"}function G(t){return Object.keys(t).length===0}function S(t,...n){if(t==null)return d;const e=t.subscribe(...n);return e.unsubscribe?()=>e.unsubscribe():e}function tt(t){let n;return S(t,e=>n=e)(),n}function nt(t,n,e){t.$$.on_destroy.push(S(n,e))}function et(t,n,e,r){if(t){const u=M(t,n,e,r);return t[0](u)}}function M(t,n,e,r){return t[1]&&r?F(e.ctx.slice(),t[1](r(n))):e.ctx}function rt(t,n,e,r){if(t[2]&&r){const u=t[2](r(e));if(n.dirty===void 0)return u;if(typeof u=="object"){const c=[],i=Math.max(n.dirty.length,u.length);for(let o=0;o<i;o+=1)c[o]=n.dirty[o]|u[o];return c}return n.dirty|u}return n.dirty}function st(t,n,e,r,u,c){if(u){const i=M(n,e,r,c);t.p(i,u)}}function ut(t){if(t.ctx.length>32){const n=[],e=t.ctx.length/32;for(let r=0;r<e;r++)n[r]=-1;return n}return-1}function ot(t){return t??""}function it(t,n,e){return t.set(e),n}function ct(t,n){t.appendChild(n)}function ft(t,n,e){t.insertBefore(n,e||null)}function H(t){t.parentNode&&t.parentNode.removeChild(t)}function at(t,n){for(let e=0;e<t.length;e+=1)t[e]&&t[e].d(n)}function lt(t){return document.createElement(t)}function q(t){return document.createTextNode(t)}function dt(){return q(" ")}function _t(){return q("")}function ht(t,n,e,r){return t.addEventListener(n,e,r),()=>t.removeEventListener(n,e,r)}function pt(t,n,e){e==null?t.removeAttribute(n):t.getAttribute(n)!==e&&t.setAttribute(n,e)}function gt(t){let n;return{p(...e){n=e,n.forEach(r=>t.push(r))},r(){n.forEach(e=>t.splice(t.indexOf(e),1))}}}function bt(t){return t===""?null:+t}function I(t){return Array.from(t.childNodes)}function mt(t,n){n=""+n,t.data!==n&&(t.data=n)}function yt(t,n){t.value=n??""}function xt(t,n,e,r){e==null?t.style.removeProperty(n):t.style.setProperty(n,e,r?"important":"")}function $t(t,n,e){t.classList[e?"add":"remove"](n)}let E;function $(t){E=t}function J(){if(!E)throw new Error("Function called outside component initialization");return E}function Et(t){J().$$.on_mount.push(t)}const m=[],C=[];let y=[];const j=[],K=Promise.resolve();let O=!1;function T(){O||(O=!0,K.then(P))}function k(t){y.push(t)}function wt(t){j.push(t)}const A=new Set;let g=0;function P(){if(g!==0)return;const t=E;do{try{for(;g<m.length;){const n=m[g];g++,$(n),Q(n.$$)}}catch(n){throw m.length=0,g=0,n}for($(null),m.length=0,g=0;C.length;)C.pop()();for(let n=0;n<y.length;n+=1){const e=y[n];A.has(e)||(A.add(e),e())}y.length=0}while(m.length);for(;j.length;)j.pop()();O=!1,A.clear(),$(t)}function Q(t){if(t.fragment!==null){t.update(),x(t.before_update);const n=t.dirty;t.dirty=[-1],t.fragment&&t.fragment.p(t.ctx,n),t.after_update.forEach(k)}}function R(t){const n=[],e=[];y.forEach(r=>t.indexOf(r)===-1?n.push(r):e.push(r)),e.forEach(r=>r()),y=n}const v=new Set;let _;function vt(){_={r:0,c:[],p:_}}function At(){_.r||x(_.c),_=_.p}function U(t,n){t&&t.i&&(v.delete(t),t.i(n))}function jt(t,n,e,r){if(t&&t.o){if(v.has(t))return;v.add(t),_.c.push(()=>{v.delete(t),r&&(e&&t.d(1),r())}),t.o(n)}else r&&r()}function Ot(t,n,e){const r=t.$$.props[n];r!==void 0&&(t.$$.bound[r]=e,e(t.$$.ctx[r]))}function kt(t){t&&t.c()}function V(t,n,e,r){const{fragment:u,after_update:c}=t.$$;u&&u.m(n,e),r||k(()=>{const i=t.$$.on_mount.map(L).filter(N);t.$$.on_destroy?t.$$.on_destroy.push(...i):x(i),t.$$.on_mount=[]}),c.forEach(k)}function W(t,n){const e=t.$$;e.fragment!==null&&(R(e.after_update),x(e.on_destroy),e.fragment&&e.fragment.d(n),e.on_destroy=e.fragment=null,e.ctx=[])}function X(t,n){t.$$.dirty[0]===-1&&(m.push(t),T(),t.$$.dirty.fill(0)),t.$$.dirty[n/31|0]|=1<<n%31}function Nt(t,n,e,r,u,c,i,o=[-1]){const f=E;$(t);const s=t.$$={fragment:null,ctx:[],props:c,update:d,not_equal:u,bound:z(),on_mount:[],on_destroy:[],on_disconnect:[],before_update:[],after_update:[],context:new Map(n.context||(f?f.$$.context:[])),callbacks:z(),dirty:o,skip_bound:!1,root:n.target||f.$$.root};i&&i(s.root);let h=!1;if(s.ctx=e?e(t,n.props||{},(a,w,...l)=>{const p=l.length?l[0]:w;return s.ctx&&u(s.ctx[a],s.ctx[a]=p)&&(!s.skip_bound&&s.bound[a]&&s.bound[a](p),h&&X(t,a)),w}):[],s.update(),h=!0,x(s.before_update),s.fragment=r?r(s.ctx):!1,n.target){if(n.hydrate){const a=I(n.target);s.fragment&&s.fragment.l(a),a.forEach(H)}else s.fragment&&s.fragment.c();n.intro&&U(t.$$.fragment),V(t,n.target,n.anchor,n.customElement),P()}$(f)}class St{$destroy(){W(this,1),this.$destroy=d}$on(n,e){if(!N(e))return d;const r=this.$$.callbacks[n]||(this.$$.callbacks[n]=[]);return r.push(e),()=>{const u=r.indexOf(e);u!==-1&&r.splice(u,1)}}$set(n){this.$$set&&!G(n)&&(this.$$.skip_bound=!0,this.$$set(n),this.$$.skip_bound=!1)}}const b=[];function Y(t,n){return{subscribe:Z(t,n).subscribe}}function Z(t,n=d){let e;const r=new Set;function u(o){if(D(t,o)&&(t=o,e)){const f=!b.length;for(const s of r)s[1](),b.push(s,t);if(f){for(let s=0;s<b.length;s+=2)b[s][0](b[s+1]);b.length=0}}}function c(o){u(o(t))}function i(o,f=d){const s=[o,f];return r.add(s),r.size===1&&(e=n(u)||d),o(t),()=>{r.delete(s),r.size===0&&e&&(e(),e=null)}}return{set:u,update:c,subscribe:i}}function zt(t,n,e){const r=!Array.isArray(t),u=r?[t]:t,c=n.length<2;return Y(e,i=>{let o=!1;const f=[];let s=0,h=d;const a=()=>{if(s)return;h();const l=n(r?f[0]:f,i);c?i(l):h=N(l)?l:d},w=u.map((l,p)=>S(l,B=>{f[p]=B,s&=~(1<<p),o&&a()},()=>{s|=1<<p}));return o=!0,a(),function(){x(w),h(),o=!1}})}export{st as A,ut as B,rt as C,U as D,jt as E,W as F,_t as G,ot as H,gt as I,yt as J,bt as K,Ot as L,vt as M,At as N,wt as O,St as S,pt as a,xt as b,nt as c,zt as d,lt as e,ft as f,tt as g,H as h,Nt as i,it as j,C as k,ht as l,dt as m,d as n,Et as o,ct as p,at as q,x as r,D as s,$t as t,q as u,mt as v,Z as w,et as x,kt as y,V as z};