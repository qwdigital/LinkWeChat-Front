import{i as t,a as e,h as s,t as n,d as r,b as i,c,N as o,e as a,f as u,g as h,m as l}from"./_@vue_shared@3.3.11@@vue-c40e50ba.js";let f;class _{constructor(t=!1){this.detached=t,this._active=!0,this.effects=[],this.cleanups=[],this.parent=f,!t&&f&&(this.index=(f.scopes||(f.scopes=[])).push(this)-1)}get active(){return this._active}run(t){if(this._active){const e=f;try{return f=this,t()}finally{f=e}}}on(){f=this}off(){f=this.parent}stop(t){if(this._active){let e,s;for(e=0,s=this.effects.length;e<s;e++)this.effects[e].stop();for(e=0,s=this.cleanups.length;e<s;e++)this.cleanups[e]();if(this.scopes)for(e=0,s=this.scopes.length;e<s;e++)this.scopes[e].stop(!0);if(!this.detached&&this.parent&&!t){const t=this.parent.scopes.pop();t&&t!==this&&(this.parent.scopes[this.index]=t,t.index=this.index)}this.parent=void 0,this._active=!1}}}function d(t){return new _(t)}function p(){return f}function v(t){f&&f.cleanups.push(t)}const g=t=>{const e=new Set(t);return e.w=0,e.n=0,e},w=t=>(t.w&m)>0,y=t=>(t.n&m)>0,R=new WeakMap;let b=0,m=1;const S=30;let k;const x=Symbol(""),O=Symbol("");class j{constructor(t,e=null,s){this.fn=t,this.scheduler=e,this.active=!0,this.deps=[],this.parent=void 0,function(t,e=f){e&&e.active&&e.effects.push(t)}(this,s)}run(){if(!this.active)return this.fn();let t=k,e=P;for(;t;){if(t===this)return;t=t.parent}try{return this.parent=k,k=this,P=!0,m=1<<++b,b<=S?(({deps:t})=>{if(t.length)for(let e=0;e<t.length;e++)t[e].w|=m})(this):E(this),this.fn()}finally{b<=S&&(t=>{const{deps:e}=t;if(e.length){let s=0;for(let n=0;n<e.length;n++){const r=e[n];w(r)&&!y(r)?r.delete(t):e[s++]=r,r.w&=~m,r.n&=~m}e.length=s}})(this),m=1<<--b,k=this.parent,P=e,this.parent=void 0,this.deferStop&&this.stop()}}stop(){k===this?this.deferStop=!0:this.active&&(E(this),this.onStop&&this.onStop(),this.active=!1)}}function E(t){const{deps:e}=t;if(e.length){for(let s=0;s<e.length;s++)e[s].delete(t);e.length=0}}let P=!0;const M=[];function W(){M.push(P),P=!1}function z(){const t=M.pop();P=void 0===t||t}function V(t,e,s){if(P&&k){let e=R.get(t);e||R.set(t,e=new Map);let n=e.get(s);n||e.set(s,n=g()),N(n)}}function N(t,e){let s=!1;b<=S?y(t)||(t.n|=m,s=!w(t)):s=!t.has(k),s&&(t.add(k),k.deps.push(t))}function A(e,s,n,r,c,o){const u=R.get(e);if(!u)return;let l=[];if("clear"===s)l=[...u.values()];else if("length"===n&&i(e)){const e=Number(r);u.forEach(((s,n)=>{("length"===n||!t(n)&&n>=e)&&l.push(s)}))}else switch(void 0!==n&&l.push(u.get(n)),s){case"add":i(e)?a(n)&&l.push(u.get("length")):(l.push(u.get(x)),h(e)&&l.push(u.get(O)));break;case"delete":i(e)||(l.push(u.get(x)),h(e)&&l.push(u.get(O)));break;case"set":h(e)&&l.push(u.get(x))}if(1===l.length)l[0]&&K(l[0]);else{const t=[];for(const e of l)e&&t.push(...e);K(g(t))}}function K(t,e){const s=i(t)?t:[...t];for(const n of s)n.computed&&q(n);for(const n of s)n.computed||q(n)}function q(t,e){(t!==k||t.allowRecurse)&&(t.scheduler?t.scheduler():t.run())}const I=l("__proto__,__v_isRef,__isVue"),B=new Set(Object.getOwnPropertyNames(Symbol).filter((t=>"arguments"!==t&&"caller"!==t)).map((t=>Symbol[t])).filter(t)),C=D();function D(){const t={};return["includes","indexOf","lastIndexOf"].forEach((e=>{t[e]=function(...t){const s=Et(this);for(let e=0,r=this.length;e<r;e++)V(s,0,e+"");const n=s[e](...t);return-1===n||!1===n?s[e](...t.map(Et)):n}})),["push","pop","shift","unshift","splice"].forEach((e=>{t[e]=function(...t){W();const s=Et(this)[e].apply(this,t);return z(),s}})),t}function F(t){const e=Et(this);return V(e,0,t),e.hasOwnProperty(t)}class G{constructor(t=!1,e=!1){this._isReadonly=t,this._shallow=e}get(s,n,r){const c=this._isReadonly,o=this._shallow;if("__v_isReactive"===n)return!c;if("__v_isReadonly"===n)return c;if("__v_isShallow"===n)return o;if("__v_raw"===n)return r===(c?o?yt:wt:o?gt:vt).get(s)||Object.getPrototypeOf(s)===Object.getPrototypeOf(r)?s:void 0;const h=i(s);if(!c){if(h&&u(C,n))return Reflect.get(C,n,r);if("hasOwnProperty"===n)return F}const l=Reflect.get(s,n,r);return(t(n)?B.has(n):I(n))?l:(c||V(s,0,n),o?l:Nt(l)?h&&a(n)?l:l.value:e(l)?c?mt(l):Rt(l):l)}}class H extends G{constructor(t=!1){super(!1,t)}set(t,e,n,r){let c=t[e];if(xt(c)&&Nt(c)&&!Nt(n))return!1;if(!this._shallow&&(Ot(n)||xt(n)||(c=Et(c),n=Et(n)),!i(t)&&Nt(c)&&!Nt(n)))return c.value=n,!0;const o=i(t)&&a(e)?Number(e)<t.length:u(t,e),h=Reflect.set(t,e,n,r);return t===Et(r)&&(o?s(n,c)&&A(t,"set",e,n):A(t,"add",e,n)),h}deleteProperty(t,e){const s=u(t,e);t[e];const n=Reflect.deleteProperty(t,e);return n&&s&&A(t,"delete",e,void 0),n}has(e,s){const n=Reflect.has(e,s);return t(s)&&B.has(s)||V(e,0,s),n}ownKeys(t){return V(t,0,i(t)?"length":x),Reflect.ownKeys(t)}}class J extends G{constructor(t=!1){super(!0,t)}set(t,e){return!0}deleteProperty(t,e){return!0}}const L=new H,Q=new J,T=new H(!0),U=t=>t,X=t=>Reflect.getPrototypeOf(t);function Y(t,e,n=!1,r=!1){const i=Et(t=t.__v_raw),c=Et(e);n||(s(e,c)&&V(i,0,e),V(i,0,c));const{has:o}=X(i),a=r?U:n?Wt:Mt;return o.call(i,e)?a(t.get(e)):o.call(i,c)?a(t.get(c)):void(t!==i&&t.get(e))}function Z(t,e=!1){const n=this.__v_raw,r=Et(n),i=Et(t);return e||(s(t,i)&&V(r,0,t),V(r,0,i)),t===i?n.has(t):n.has(t)||n.has(i)}function $(t,e=!1){return t=t.__v_raw,!e&&V(Et(t),0,x),Reflect.get(t,"size",t)}function tt(t){t=Et(t);const e=Et(this);return X(e).has.call(e,t)||(e.add(t),A(e,"add",t,t)),this}function et(t,e){e=Et(e);const n=Et(this),{has:r,get:i}=X(n);let c=r.call(n,t);c||(t=Et(t),c=r.call(n,t));const o=i.call(n,t);return n.set(t,e),c?s(e,o)&&A(n,"set",t,e):A(n,"add",t,e),this}function st(t){const e=Et(this),{has:s,get:n}=X(e);let r=s.call(e,t);r||(t=Et(t),r=s.call(e,t)),n&&n.call(e,t);const i=e.delete(t);return r&&A(e,"delete",t,void 0),i}function nt(){const t=Et(this),e=0!==t.size,s=t.clear();return e&&A(t,"clear",void 0,void 0),s}function rt(t,e){return function(s,n){const r=this,i=r.__v_raw,c=Et(i),o=e?U:t?Wt:Mt;return!t&&V(c,0,x),i.forEach(((t,e)=>s.call(n,o(t),o(e),r)))}}function it(t,e,s){return function(...n){const r=this.__v_raw,i=Et(r),c=h(i),o="entries"===t||t===Symbol.iterator&&c,a="keys"===t&&c,u=r[t](...n),l=s?U:e?Wt:Mt;return!e&&V(i,0,a?O:x),{next(){const{value:t,done:e}=u.next();return e?{value:t,done:e}:{value:o?[l(t[0]),l(t[1])]:l(t),done:e}},[Symbol.iterator](){return this}}}}function ct(t){return function(...e){return"delete"!==t&&("clear"===t?void 0:this)}}function ot(){const t={get(t){return Y(this,t)},get size(){return $(this)},has:Z,add:tt,set:et,delete:st,clear:nt,forEach:rt(!1,!1)},e={get(t){return Y(this,t,!1,!0)},get size(){return $(this)},has:Z,add:tt,set:et,delete:st,clear:nt,forEach:rt(!1,!0)},s={get(t){return Y(this,t,!0)},get size(){return $(this,!0)},has(t){return Z.call(this,t,!0)},add:ct("add"),set:ct("set"),delete:ct("delete"),clear:ct("clear"),forEach:rt(!0,!1)},n={get(t){return Y(this,t,!0,!0)},get size(){return $(this,!0)},has(t){return Z.call(this,t,!0)},add:ct("add"),set:ct("set"),delete:ct("delete"),clear:ct("clear"),forEach:rt(!0,!0)};return["keys","values","entries",Symbol.iterator].forEach((r=>{t[r]=it(r,!1,!1),s[r]=it(r,!0,!1),e[r]=it(r,!1,!0),n[r]=it(r,!0,!0)})),[t,s,e,n]}const[at,ut,ht,lt]=ot();function ft(t,e){const s=e?t?lt:ht:t?ut:at;return(e,n,r)=>"__v_isReactive"===n?!t:"__v_isReadonly"===n?t:"__v_raw"===n?e:Reflect.get(u(s,n)&&n in e?s:e,n,r)}const _t={get:ft(!1,!1)},dt={get:ft(!1,!0)},pt={get:ft(!0,!1)},vt=new WeakMap,gt=new WeakMap,wt=new WeakMap,yt=new WeakMap;function Rt(t){return xt(t)?t:St(t,!1,L,_t,vt)}function bt(t){return St(t,!1,T,dt,gt)}function mt(t){return St(t,!0,Q,pt,wt)}function St(t,s,r,i,c){if(!e(t))return t;if(t.__v_raw&&(!s||!t.__v_isReactive))return t;const o=c.get(t);if(o)return o;const a=(u=t).__v_skip||!Object.isExtensible(u)?0:function(t){switch(t){case"Object":case"Array":return 1;case"Map":case"Set":case"WeakMap":case"WeakSet":return 2;default:return 0}}(n(u));var u;if(0===a)return t;const h=new Proxy(t,2===a?i:r);return c.set(t,h),h}function kt(t){return xt(t)?kt(t.__v_raw):!(!t||!t.__v_isReactive)}function xt(t){return!(!t||!t.__v_isReadonly)}function Ot(t){return!(!t||!t.__v_isShallow)}function jt(t){return kt(t)||xt(t)}function Et(t){const e=t&&t.__v_raw;return e?Et(e):t}function Pt(t){return r(t,"__v_skip",!0),t}const Mt=t=>e(t)?Rt(t):t,Wt=t=>e(t)?mt(t):t;function zt(t){P&&k&&N((t=Et(t)).dep||(t.dep=g()))}function Vt(t,e){const s=(t=Et(t)).dep;s&&K(s)}function Nt(t){return!(!t||!0!==t.__v_isRef)}function At(t){return qt(t,!1)}function Kt(t){return qt(t,!0)}function qt(t,e){return Nt(t)?t:new It(t,e)}class It{constructor(t,e){this.__v_isShallow=e,this.dep=void 0,this.__v_isRef=!0,this._rawValue=e?t:Et(t),this._value=e?t:Mt(t)}get value(){return zt(this),this._value}set value(t){const e=this.__v_isShallow||Ot(t)||xt(t);t=e?t:Et(t),s(t,this._rawValue)&&(this._rawValue=t,this._value=e?t:Mt(t),Vt(this))}}function Bt(t){return Nt(t)?t.value:t}const Ct={get:(t,e,s)=>Bt(Reflect.get(t,e,s)),set:(t,e,s,n)=>{const r=t[e];return Nt(r)&&!Nt(s)?(r.value=s,!0):Reflect.set(t,e,s,n)}};function Dt(t){return kt(t)?t:new Proxy(t,Ct)}class Ft{constructor(t){this.dep=void 0,this.__v_isRef=!0;const{get:e,set:s}=t((()=>zt(this)),(()=>Vt(this)));this._get=e,this._set=s}get value(){return this._get()}set value(t){this._set(t)}}function Gt(t){return new Ft(t)}function Ht(t){const e=i(t)?new Array(t.length):{};for(const s in t)e[s]=Tt(t,s);return e}class Jt{constructor(t,e,s){this._object=t,this._key=e,this._defaultValue=s,this.__v_isRef=!0}get value(){const t=this._object[this._key];return void 0===t?this._defaultValue:t}set value(t){this._object[this._key]=t}get dep(){return t=Et(this._object),e=this._key,null==(s=R.get(t))?void 0:s.get(e);var t,e,s}}class Lt{constructor(t){this._getter=t,this.__v_isRef=!0,this.__v_isReadonly=!0}get value(){return this._getter()}}function Qt(t,s,n){return Nt(t)?t:c(t)?new Lt(t):e(t)&&arguments.length>1?Tt(t,s,n):At(t)}function Tt(t,e,s){const n=t[e];return Nt(n)?n:new Jt(t,e,s)}class Ut{constructor(t,e,s,n){this._setter=e,this.dep=void 0,this.__v_isRef=!0,this.__v_isReadonly=!1,this._dirty=!0,this.effect=new j(t,(()=>{this._dirty||(this._dirty=!0,Vt(this))})),this.effect.computed=this,this.effect.active=this._cacheable=!n,this.__v_isReadonly=s}get value(){const t=Et(this);return zt(t),!t._dirty&&t._cacheable||(t._dirty=!1,t._value=t.effect.run()),t._value}set value(t){this._setter(t)}}function Xt(t,e,s=!1){let n,r;const i=c(t);i?(n=t,r=o):(n=t.get,r=t.set);return new Ut(n,r,i||!r,s)}export{_ as E,j as R,Rt as a,jt as b,Xt as c,Ot as d,kt as e,W as f,p as g,z as h,Nt as i,Et as j,A as k,Kt as l,Pt as m,Qt as n,mt as o,Dt as p,Gt as q,At as r,bt as s,V as t,Bt as u,v,d as w,Ht as x};
